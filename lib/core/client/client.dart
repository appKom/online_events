import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';

import '/core/models/article_model.dart';
import '/core/models/attendee_info_model.dart';
import '/core/models/attendees_list.dart';
import '/core/models/hobby_model.dart';
import '/core/models/user_model.dart';
import '/services/authenticator.dart';
import '../models/event_attendance_model.dart';
import '../models/event_model.dart';

abstract class Client {
  static const endpoint = 'https://old.online.ntnu.no';
  static String? refreshToken;
  static int? expiresIn;

  static Future<void> launchInBrowser(String url) async {
    if (!await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication)) {
      throw 'Unable to open $url';
    }
  }

  static final ValueNotifier<Map<String, EventModel>> eventsCache = ValueNotifier({});
  static final ValueNotifier<UserModel?> userCache = ValueNotifier(null);
  static final ValueNotifier<Set<EventAttendanceModel>> eventAttendanceCache = ValueNotifier({});
  static final ValueNotifier<Map<String, GroupModel>> hobbiesCache = ValueNotifier({});
  static ValueNotifier<Map<String, ArticleModel>> articlesCache = ValueNotifier({});

  static Future<Map<String, EventModel>> fetchEventsForPage(int page) async {
    String url = '$endpoint/api/v1/event/events/?page=$page';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final body = utf8.decode(response.bodyBytes, allowMalformed: true);
      final bodyJson = jsonDecode(body);
      final List<EventModel> events =
          bodyJson['results'].map<EventModel>((eventJson) => EventModel.fromJson(eventJson)).toList();

      Map<String, EventModel> eventMap = {};
      for (int i = 0; i < events.length; i++) {
        final event = events[i];
        final id = event.id.toString();
        eventMap.putIfAbsent(id, () => event);
      }
      return eventMap;
    } else {
      return {};
    }
  }

  static Future<Map<String, EventModel>?> getEvents({List<int> pages = const [1, 2, 3, 4]}) async {
    List<Future<Map<String, EventModel>>> futures = pages.map((page) => fetchEventsForPage(page)).toList();
    List<Map<String, EventModel>> results = await Future.wait(futures);

    Map<String, EventModel> combinedEventMap = {};
    for (var result in results) {
      combinedEventMap.addAll(result);
    }

    eventsCache.value = Map.from(eventsCache.value)..addAll(combinedEventMap);

    return eventsCache.value;
  }

  static Future<EventModel?> getEventWithId(int eventId) async {
    String url = '$endpoint/api/v1/event/events/$eventId';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final body = utf8.decode(response.bodyBytes, allowMalformed: true);
        final bodyJson = jsonDecode(body);
        return EventModel.fromJson(bodyJson);
      } else {
        return null;
      }
    } catch (error) {
      print('Error fetching event with id $eventId: $error');
      return null;
    }
  }

  static Future<Map<String, EventModel>?> getEventsWithIds({List<int> eventIds = const []}) async {
    Map<String, EventModel> eventMap = {};

    var futures = eventIds.map((eventId) => getEventWithId(eventId));

    final results = await Future.wait(futures);

    for (var event in results) {
      if (event != null) {
        eventMap.putIfAbsent(event.id.toString(), () => event);
      }
    }

    eventsCache.value = Map.from(eventsCache.value)..addAll(eventMap);

    return eventsCache.value;
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
      final body = utf8.decode(response.bodyBytes, allowMalformed: true);
      final bodyJson = jsonDecode(body);
      userCache.value = UserModel.fromJson(bodyJson);
      return userCache.value;
    }

    return null;
  }

  static Future<AttendeeInfoModel?> getEventAttendance(int eventId) async {
    final url = '$endpoint/api/v1/event/attendance-events/$eventId/';

    final response = await http.get(
      Uri.parse(url),
    );

    if (response.statusCode == 200) {
      final body = utf8.decode(response.bodyBytes);
      final bodyJson = jsonDecode(body);
      return AttendeeInfoModel.fromJson(bodyJson);
    } else {
      return null;
    }
  }

  static Future<AttendeeInfoModel?> getEventAttendanceLoggedIn(int eventId) async {
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
      final body = utf8.decode(response.bodyBytes);
      final bodyJson = jsonDecode(body);
      return AttendeeInfoModel.fromJson(bodyJson);
    } else {
      return null;
    }
  }

  static Future<List<AttendeesList>?> getEventAttendees(int eventId) async {
    final accessToken = Authenticator.credentials?.accessToken;

    if (accessToken == null) return null;

    final url = '$endpoint/api/v1/event/attendance-events/$eventId/public-attendees/';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final body = utf8.decode(response.bodyBytes, allowMalformed: true);
      final bodyJson = jsonDecode(body) as List;

      return bodyJson.map<AttendeesList>((json) => AttendeesList.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  static Future<List<AttendeesList>> getEventWaitlists(int eventId) async {
    final accessToken = Authenticator.credentials?.accessToken;

    if (accessToken == null) return [];

    final url = '$endpoint/api/v1/event/attendance-events/$eventId/public-on-waitlist/';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final body = utf8.decode(response.bodyBytes, allowMalformed: true);
      final bodyJson = jsonDecode(body) as List;

      return bodyJson.map<AttendeesList>((json) => AttendeesList.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  static Future<List<ArticleModel>> fetchArticles(int pageNumber) async {
    final articles = await fetch(
      '$endpoint/api/v1/articles/?ordering=-created_date&page=$pageNumber',
      ArticleModel.fromJson,
    );

    if (articles == null) return [];

    Map<String, ArticleModel> articleMap = {};

    for (var article in articles) {
      articleMap.putIfAbsent(article.createdDate, () => article);
    }

    articlesCache.value = Map.from(articlesCache.value)..addAll(articleMap);

    return articles;
  }

  static Future<List<T>?> fetch<T>(String url, T Function(Map<String, dynamic> json) jsonReviver) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final body = utf8.decode(response.bodyBytes, allowMalformed: true);
      final bodyJson = jsonDecode(body);

      // DO NOT CHANGE. HOLY LINE
      return bodyJson['results'].map((json) => jsonReviver(json)).cast<T>().toList();
    }

    return null;
  }

  static Future<int> _getGroupPageCount() async {
    String url = '$endpoint/api/v1/hobbys/?ordering=-priority&page=1';
    Response response = await http.get(Uri.parse(url));

    if (response.statusCode != 200) return 0;

    final body = utf8.decode(response.bodyBytes, allowMalformed: true);
    final bodyJson = jsonDecode(body);
    final totalCount = bodyJson['count'];
    final pageSize = bodyJson['results'].length;
    final pageCount = (totalCount / pageSize).ceil();

    return pageCount;
  }

  static Future<void> getGroups() async {
    Map<String, GroupModel> groupMap = {};

    int pageCount = await _getGroupPageCount();

    if (pageCount == 0) return;

    List<int> pages = List.generate(pageCount, (index) => index + 1);

    var futures = pages.map((page) {
      String url = '$endpoint/api/v1/hobbys/?page=$page';
      return http.get(Uri.parse(url));
    }).toList();

    var responses = await Future.wait(futures);

    for (Response response in responses) {
      if (response.statusCode != 200) continue;

      final body = utf8.decode(response.bodyBytes, allowMalformed: true);
      final bodyJson = jsonDecode(body);
      final groups = bodyJson['results'].map<GroupModel>((hobbyJson) => GroupModel.fromJson(hobbyJson)).toList();

      for (GroupModel group in groups) {
        groupMap.putIfAbsent(group.id.toString(), () => group);
      }
    }

    hobbiesCache.value = Map.from(hobbiesCache.value)..addAll(groupMap);
  }
}
