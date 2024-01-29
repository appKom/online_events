import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:online_events/core/models/article_model.dart';
import 'package:online_events/core/models/attended_events.dart';
import 'package:online_events/core/models/attendee_info_model.dart';
import 'package:online_events/core/models/attendees_list.dart';
import 'package:online_events/core/models/user_model.dart';
import 'package:online_events/core/models/waitlist.dart';

import '../models/event_model.dart';

abstract class Client {
  static const endpoint = 'https://old.online.ntnu.no';
  static String? accessToken;
  static String? refreshToken;
  static int? expiresIn;
  static DateTime? _tokenSetTime;

  static const _storage = FlutterSecureStorage();

  static Future<void> saveTokensToSecureStorage() async {
    await _storage.write(key: 'accessToken', value: accessToken);
    await _storage.write(key: 'refreshToken', value: refreshToken);
    await _storage.write(key: 'expiresIn', value: expiresIn.toString());
    await _storage.write(key: 'tokenSetTime', value: _tokenSetTime?.toIso8601String());
    print('Tokens saved to secure storage successfully.');
  }

  static Future<void> loadTokensFromSecureStorage() async {
    try {
      accessToken = await _storage.read(key: 'accessToken');
      refreshToken = await _storage.read(key: 'refreshToken');
      final expiresInStr = await _storage.read(key: 'expiresIn');
      expiresIn = expiresInStr != null ? int.tryParse(expiresInStr) : null;
      final tokenSetTimeStr = await _storage.read(key: 'tokenSetTime');
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

  static Future<List<Waitlist>> getEventWaitlists(int eventId) async {
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

      return jsonResponse.map<Waitlist>((json) => Waitlist.fromJson(json)).toList();
    } else {
      print('Failed to fetch event waitlist from $url');
      return [];
    }
  }

  static ValueNotifier<Set<ArticleModel>> articlesCache = ValueNotifier({});

  static Future<List<ArticleModel>?> fetchArticles() async {
    // await Future.delayed(const Duration(seconds: 5));
    final articles = await fetch('$endpoint/api/v1/articles/', ArticleModel.fromJson);

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
