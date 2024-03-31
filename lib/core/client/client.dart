import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:online/core/models/hobby_model.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/event_model.dart';
import '/core/models/article_model.dart';
import '/core/models/attendee_info_model.dart';
import '/core/models/attendees_list.dart';
import '/core/models/user_model.dart';
import '/services/authenticator.dart';

/// Info about user's attendance at an event.
/// Is the event paid, has the user paid for the event, did the user show up, etc.
class EventAttendanceModel {
  final int id;
  final bool attended;
  final String timestamp;
  final bool isPaidEvent;
  final bool hasPaidForEvent;

  EventAttendanceModel({
    required this.id,
    required this.attended,
    required this.timestamp,
    required this.isPaidEvent,
    required this.hasPaidForEvent,
  });

  factory EventAttendanceModel.fromJson(Map<String, dynamic> json) {
    return EventAttendanceModel(
      id: json['event'],
      attended: json['attended'],
      timestamp: json['timestamp'],
      isPaidEvent: json['paid'],
      hasPaidForEvent: json['has_paid'],
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! EventAttendanceModel) return false;
    if (other.runtimeType != runtimeType) return false;
    return id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}

abstract class Client {
  static const endpoint = 'https://old.online.ntnu.no';
  static String? refreshToken;
  static int? expiresIn;

  static Future<void> launchInBrowser(String url) async {
    if (!await launchUrl(Uri.parse(url),
        mode: LaunchMode.externalApplication)) {
      throw 'Unable to open $url';
    }
  }

  static ValueNotifier<Set<EventModel>> eventsCache = ValueNotifier({});
  static ValueNotifier<Set<EventModel>> eventsIdsCache = ValueNotifier({});
  static ValueNotifier<UserModel?> userCache = ValueNotifier(null);

  static Future<Set<EventModel>?> getEvents(
      {List<int> pages = const [1, 2, 3, 4]}) async {
    Set<EventModel> allEvents = {};

    for (int page in pages) {
      String url = '$endpoint/api/v1/event/events/?page=$page';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final responseBody =
            utf8.decode(response.bodyBytes, allowMalformed: true);
        final jsonResponse = jsonDecode(responseBody);
        final events = jsonResponse['results']
            .map<EventModel>((eventJson) => EventModel.fromJson(eventJson))
            .toList();

        allEvents.addAll(events);
      }
    }

    // Add any new events fetched
    if (allEvents.isNotEmpty) {
      eventsCache.value = Set.from(eventsCache.value)..addAll(allEvents);
    }

    return allEvents;
  }

  static Future<Set<EventModel>?> getEventsWithIds(
      {List<int> eventIds = const []}) async {
    Set<EventModel> eventsWithId = {};

    var futures = eventIds.map((eventId) {
      String url = '$endpoint/api/v1/event/events/$eventId';
      return http.get(Uri.parse(url)).then((response) {
        if (response.statusCode == 200) {
          final responseBody =
              utf8.decode(response.bodyBytes, allowMalformed: true);
          final jsonResponse = jsonDecode(responseBody);
          return EventModel.fromJson(jsonResponse);
        } else {
          return null;
        }
      }).catchError((error) {
        print('Error fetching event with id $eventId: $error');
        return null;
      });
    });

    final results = await Future.wait(futures);

    for (var event in results) {
      if (event != null) {
        eventsWithId.add(event);
      }
    }

    if (eventsWithId.isNotEmpty) {
      eventsIdsCache.value = Set.from(eventsIdsCache.value)
        ..addAll(eventsWithId);
    }

    return eventsWithId;
  }

  static Future<UserModel?> getUserProfile() async {
    final accessToken = Authenticator.credentials?.accessToken;

    if (accessToken == null) return null;

    const url = '$endpoint/api/v1/profile/';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final responseBody =
          utf8.decode(response.bodyBytes, allowMalformed: true);
      final jsonResponse = jsonDecode(responseBody);
      userCache.value = UserModel.fromJson(jsonResponse);
      return userCache.value;
    }

    return null;
  }

  static final ValueNotifier<Set<EventAttendanceModel>> eventAttendanceCache =
      ValueNotifier({});

  /// Get all events that user has attended or is attending
  static Future<List<EventAttendanceModel>> getAttendanceEvents({
    required int userId,
    required int pageCount,
  }) async {
    final accessToken = Authenticator.credentials?.accessToken;

    if (accessToken == null) return [];

    final url =
        '$endpoint/api/v1/event/attendees/?page=$pageCount&ordering=-id&user=$userId';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    final results = <EventAttendanceModel>[];

    final body = utf8.decode(response.bodyBytes, allowMalformed: true);
    final jsonResults = jsonDecode(body)['results'];

    if (jsonResults != null) {
      for (var json in jsonResults) {
        var event = EventAttendanceModel.fromJson(json);
        if (!eventAttendanceCache.value
            .any((cachedEvent) => cachedEvent.id == event.id)) {
          results.add(event);
        }
      }
      if (results.isNotEmpty) {
        eventAttendanceCache.value = Set.from(eventAttendanceCache.value)
          ..addAll(results);
      }
    }

    return results;
  }

  static Future<AttendeeInfoModel?> getEventAttendance(int eventId) async {
    final url = '$endpoint/api/v1/event/attendance-events/$eventId/';

    final response = await http.get(
      Uri.parse(url),
    );

    if (response.statusCode == 200) {
      final String decodedResponseBody = utf8.decode(response.bodyBytes);
      final jsonResponse = jsonDecode(decodedResponseBody);
      return AttendeeInfoModel.fromJson(jsonResponse);
    } else {
      return null;
    }
  }

  static Future<AttendeeInfoModel?> getEventAttendanceLoggedIn(
      int eventId) async {
    final accessToken = Authenticator.credentials?.accessToken;

    if (accessToken == null) return null;

    final url = '$endpoint/api/v1/event/attendance-events/$eventId/';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final String decodedResponseBody = utf8.decode(response.bodyBytes);
      final jsonResponse = jsonDecode(decodedResponseBody);
      return AttendeeInfoModel.fromJson(jsonResponse);
    } else {
      return null;
    }
  }

  static Future<List<AttendeesList>?> getEventAttendees(int eventId) async {
    final accessToken = Authenticator.credentials?.accessToken;

    if (accessToken == null) return null;

    final url =
        '$endpoint/api/v1/event/attendance-events/$eventId/public-attendees/';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final responseBody =
          utf8.decode(response.bodyBytes, allowMalformed: true);
      final jsonResponse = jsonDecode(responseBody) as List;

      return jsonResponse
          .map<AttendeesList>((json) => AttendeesList.fromJson(json))
          .toList();
    } else {
      return [];
    }
  }

  static Future<List<AttendeesList>> getEventWaitlists(int eventId) async {
    final accessToken = Authenticator.credentials?.accessToken;

    if (accessToken == null) return [];

    final url =
        '$endpoint/api/v1/event/attendance-events/$eventId/public-on-waitlist/';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final responseBody =
          utf8.decode(response.bodyBytes, allowMalformed: true);
      final jsonResponse = jsonDecode(responseBody) as List;

      return jsonResponse
          .map<AttendeesList>((json) => AttendeesList.fromJson(json))
          .toList();
    } else {
      return [];
    }
  }

  static ValueNotifier<Set<ArticleModel>> articlesCache = ValueNotifier({});

  static Future<List<ArticleModel>?> fetchArticles(int pageNumber) async {
    final articles = await fetch(
      '$endpoint/api/v1/articles/?ordering=-created_date&page=$pageNumber',
      ArticleModel.fromJson,
    );

    // Add any new articles fetched
    if (articles != null) {
      articlesCache.value = Set.from(articlesCache.value)..addAll(articles);
    }

    return articles;
  }

  static Future<List<T>?> fetch<T>(
      String url, T Function(Map<String, dynamic> json) jsonReviver) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final responseBody =
          utf8.decode(response.bodyBytes, allowMalformed: true);
      final jsonResponse = jsonDecode(responseBody);

      // DO NOT CHANGE. HOLY LINE
      return jsonResponse['results']
          .map((json) => jsonReviver(json))
          .cast<T>()
          .toList();
    }

    return null;
  }

  static ValueNotifier<Set<HobbyModel>> hobbiesCache = ValueNotifier({});

  static Future<void> getHobbies() async {
    Set<HobbyModel> allHobbies = {};

    String initialUrl = '$endpoint/api/v1/hobbys/?page=1';
    var initialResponse = await http.get(Uri.parse(initialUrl));
    if (initialResponse.statusCode == 200) {
      final initialResponseBody =
          utf8.decode(initialResponse.bodyBytes, allowMalformed: true);
      final initialJsonResponse = jsonDecode(initialResponseBody);
      final totalCount = initialJsonResponse['count'];
      final pageSize = initialJsonResponse['results'].length;
      final pageCount = (totalCount / pageSize).ceil();

      List<int> pages = List.generate(pageCount, (index) => index + 1);

      var futures = pages.map((page) {
        String url = '$endpoint/api/v1/hobbys/?page=$page';
        return http.get(Uri.parse(url));
      }).toList();

      var responses = await Future.wait(futures);

      for (var response in responses) {
        if (response.statusCode == 200) {
          final responseBody =
              utf8.decode(response.bodyBytes, allowMalformed: true);
          final jsonResponse = jsonDecode(responseBody);
          final hobbies = jsonResponse['results']
              .map<HobbyModel>((hobbyJson) => HobbyModel.fromJson(hobbyJson))
              .toList();

          allHobbies.addAll(hobbies);
        }
      }
      if (allHobbies.isNotEmpty) {
        hobbiesCache.value = Set.from(hobbiesCache.value)..addAll(allHobbies);
      }
    }
  }
}
