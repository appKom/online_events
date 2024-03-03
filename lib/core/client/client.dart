import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../models/event_model.dart';
import '/core/models/article_model.dart';
import '/core/models/attended_events.dart';
import '/core/models/attendee_info_model.dart';
import '/core/models/attendees_list.dart';
import '/core/models/user_model.dart';
import '/services/authenticator.dart';

abstract class Client {
  static const endpoint = 'https://old.online.ntnu.no';
  static String? accessToken;
  static String? refreshToken;
  static int? expiresIn;

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
    final response = await http.post(
      Uri.parse('https://old.online.ntnu.no/openid/token'),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'refresh_token': refreshToken?? '',
        'grant_type': 'refresh_token',
        'client_id': '972717',
      },
    );

    switch (response.statusCode) {
      case 200:
        final responseBody = jsonDecode(response.body);
        setAccessToken(responseBody['access_token']);
        setExpiresIn(responseBody['expires_in']);
        return true;
      default:
        return false;

  static Future<void> launchInBrowser(String url) async {
    if (!await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication)) {
      throw 'Unable to open $url';
    }
  }

  static ValueNotifier<Set<EventModel>> eventsCache = ValueNotifier({});
  static ValueNotifier<UserModel?> userCache = ValueNotifier(null);

  static Future<Set<EventModel>?> getEvents({List<int> pages = const [1, 2, 3, 4]}) async {
    Set<EventModel> allEvents = {};

    for (int page in pages) {
      String url = page == 1 ? '$endpoint/api/v1/event/events/' : '$endpoint/api/v1/event/events/?page=$page';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes, allowMalformed: true);
        final jsonResponse = jsonDecode(responseBody);
        final events = jsonResponse['results'].map<EventModel>((eventJson) => EventModel.fromJson(eventJson)).toList();

        allEvents.addAll(events);
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
      }
    }

    return pastEvents;
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
      final responseBody = utf8.decode(response.bodyBytes, allowMalformed: true);
      final jsonResponse = jsonDecode(responseBody);
      userCache.value = UserModel.fromJson(jsonResponse);
      return userCache.value;
    }

    return null;
  }

  static Future<List<AttendedEvents>?> getAttendedEvents(int userId) async {
    final accessToken = Authenticator.credentials?.accessToken;

    if (accessToken == null) return null;

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
      final responseBody = utf8.decode(response.bodyBytes, allowMalformed: true);
      final jsonResponse = jsonDecode(responseBody) as List;

      return jsonResponse.map<AttendeesList>((json) => AttendeesList.fromJson(json)).toList();
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
