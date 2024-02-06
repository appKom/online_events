import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/event_model.dart';
import '/core/models/article_model.dart';
import '/core/models/attended_events.dart';
import '/core/models/attendee_info_model.dart';
import '/core/models/attendees_list.dart';
import '/core/models/user_model.dart';
import '/services/secure_storage.dart';

abstract class Client {
  static const endpoint = 'https://old.online.ntnu.no';
  static String? accessToken;
  static String? refreshToken;
  static int? expiresIn;
  static DateTime? _tokenSetTime;

  static Future<void> saveTokensToSecureStorage() async {
    await SecureStorage.write('accessToken', accessToken ?? '');
    await SecureStorage.write('refreshToken', refreshToken ?? '');
    await SecureStorage.write('expiresIn', (expiresIn?.toString()) ?? '');
    await SecureStorage.write('tokenSetTime', (_tokenSetTime?.toIso8601String()) ?? '');
  }

  static Future<void> loadTokensFromSecureStorage() async {
    try {
      accessToken = await SecureStorage.read('accessToken');
      refreshToken = await SecureStorage.read('refreshToken');
      final expiresInStr = await SecureStorage.read('expiresIn');
      expiresIn = expiresInStr != null ? int.tryParse(expiresInStr) : null;
      final tokenSetTimeStr = await SecureStorage.read('tokenSetTime');
      _tokenSetTime = tokenSetTimeStr != null ? DateTime.tryParse(tokenSetTimeStr) : null;
      print('Tokens loaded from secure storage successfully.');
    } catch (e) {
      print('Error loading tokens from secure storage: $e');
    }
  }

  static void setAccessToken(String token) {
    accessToken = token;
    _tokenSetTime = DateTime.now();
    saveTokensToSecureStorage();
  }

  static void setExpiresIn(int expiresIn) {
    if (_tokenSetTime != null) {
      _tokenSetTime = _tokenSetTime!.add(Duration(seconds: expiresIn));
      saveTokensToSecureStorage();
    }
  }

  static void setRefreshToken(String token) {
    refreshToken = token;
    saveTokensToSecureStorage();
  }

  static Future<bool> _refreshToken() async {
    try {
      final response = await http.post(
        Uri.parse('https://old.online.ntnu.no/openid/token'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'refresh_token': refreshToken,
          'grant_type': 'refresh_token',
          'client_id': '972717',
        },
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        setAccessToken(responseBody['access_token']);
        setExpiresIn(responseBody['expires_in']);
        return true;
      } else {
        print('Failed to refresh token: ${response.statusCode} ${response.reasonPhrase} ${response.body}');
        return false;
      }
    } catch (e) {
      print('Exception during token refresh: $e');
      return false;
    }
  }

  static bool tokenExpired() {
    if (_tokenSetTime == null) return true;
    return DateTime.now().isAfter(_tokenSetTime!);
  }

  static ValueNotifier<Set<EventModel>> eventsCache = ValueNotifier({});

  static Future<Set<EventModel>?> getEvents({List<int> pages = const [1, 2, 3, 4]}) async {
    // await Future.delayed(const Duration(seconds: 5));

    Set<EventModel> allEvents = {};

    for (int page in pages) {
      String url = page == 1 ? '$endpoint/api/v1/event/events/' : '$endpoint/api/v1/event/events/?page=$page';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes, allowMalformed: true);
        final jsonResponse = jsonDecode(responseBody);
        final events = jsonResponse['results'].map<EventModel>((eventJson) => EventModel.fromJson(eventJson)).toList();

        allEvents.addAll(events);
      } else {
        print('Failed to fetch events from $url');
      }
    }

    // Add any new events fetched
    if (allEvents.isNotEmpty) {
      eventsCache.value = Set.from(eventsCache.value)..addAll(allEvents);
    }

    return allEvents;
  }

  static Future<List<EventModel>?> getPastEvents() async {
    List<EventModel> pastEvents = [];

    // URLs for each page
    List<String> urls = [
      '$endpoint/api/v1/event/events/?page?5',
      '$endpoint/api/v1/event/events/?page=6',
      '$endpoint/api/v1/event/events/?page=7',
      '$endpoint/api/v1/event/events/?page=8',
    ];

    for (var url in urls) {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes, allowMalformed: true);
        final jsonResponse = jsonDecode(responseBody);

        final events = jsonResponse['results'].map<EventModel>((eventJson) => EventModel.fromJson(eventJson)).toList();

        pastEvents.addAll(events);
      } else {
        print('Failed to fetch events from $url');
      }
    }

    return pastEvents;
  }

  static Future<bool> fetchRefreshToken() async {
    if (tokenExpired()) return await _refreshToken();
    return true;
  }

  static ValueNotifier<UserModel?> userCache = ValueNotifier(null);

  static Future<UserModel?> getUserProfile() async {
    if (!await fetchRefreshToken()) return null;

    const url = '$endpoint/api/v1/profile/';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final responseBody = utf8.decode(response.bodyBytes, allowMalformed: true);
      final jsonResponse = jsonDecode(responseBody);
      userCache.value = UserModel.fromJson(jsonResponse);
      return userCache.value;
    }

    return null;
  }

  static Future<List<AttendedEvents>?> getAttendedEvents(int userId) async {
    if (!await fetchRefreshToken()) return null;

    List<AttendedEvents> allAttendees = [];

    // URLs for each page
    List<String> urls = [
      '$endpoint/api/v1/event/attendees/?allow_pictures=&attended=&event=&extras=&ordering=-id&show_as_attending_event=&user=$userId',
      '$endpoint/api/v1/event/attendees/?allow_pictures=&attended=&event=&extras=&ordering=-id&page=2&show_as_attending_event=&user=$userId',
    ];

    for (var url in urls) {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes, allowMalformed: true);
        final jsonResponse = jsonDecode(responseBody);

        final attendees = jsonResponse['results']
            .map<AttendedEvents>((attendeeJson) => AttendedEvents.fromJson(attendeeJson))
            .toList();

        allAttendees.addAll(attendees);
      } else {
        print('Failed to fetch attendees info from $url');
      }
    }

    return allAttendees;
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
      print('Failed to fetch attendance');
      return null;
    }
  }

  static Future<AttendeeInfoModel?> getEventAttendanceLoggedIn(int eventId) async {
    if (!await fetchRefreshToken()) return null;

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
      print('Failed to fetch attendance');
      return null;
    }
  }

  static Future<List<AttendeesList>?> getEventAttendees(int eventId) async {
    if (!await fetchRefreshToken()) return null;

    final url = '$endpoint/api/v1/event/attendance-events/$eventId/public-attendees/';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final responseBody = utf8.decode(response.bodyBytes, allowMalformed: true);
      final jsonResponse = jsonDecode(responseBody) as List;

      return jsonResponse.map<AttendeesList>((json) => AttendeesList.fromJson(json)).toList();
    } else {
      print('Failed to fetch event attendees from $url');
      return [];
    }
  }

  static Future<List<AttendeesList>> getEventWaitlists(int eventId) async {
    if (tokenExpired()) {
      bool refreshed = await _refreshToken();
      if (!refreshed) {
        print('Token refresh failed, cannot fetch event attendees');
        return [];
      }
    }
    final url = '$endpoint/api/v1/event/attendance-events/$eventId/public-on-waitlist/';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final responseBody = utf8.decode(response.bodyBytes, allowMalformed: true);
      final jsonResponse = jsonDecode(responseBody) as List;

      return jsonResponse.map<AttendeesList>((json) => AttendeesList.fromJson(json)).toList();
    } else {
      print('Failed to fetch event waitlist from $url');
      return [];
    }
  }

  static ValueNotifier<Set<ArticleModel>> articlesCache = ValueNotifier({});

  static Future<List<ArticleModel>?> fetchArticles(int pageNumber) async {
    // await Future.delayed(const Duration(seconds: 5));
    final articles = await fetch('$endpoint/api/v1/articles/?ordering=-created_date&page=$pageNumber', ArticleModel.fromJson);

    // Add any new articles fetched
    if (articles != null) {
      articlesCache.value = Set.from(articlesCache.value)..addAll(articles);
    }

    return articles;
  }

  static Future<List<T>?> fetch<T>(String url, T Function(Map<String, dynamic> json) jsonReviver) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final responseBody = utf8.decode(response.bodyBytes, allowMalformed: true);
      final jsonResponse = jsonDecode(responseBody);

      // DO NOT CHANGE. HOLY LINE
      return jsonResponse['results'].map((json) => jsonReviver(json)).cast<T>().toList();
    }

    return null;
  }
}
