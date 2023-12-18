import 'dart:convert';

import 'package:online_events/core/models/article_model.dart';
import 'package:online_events/core/models/attendee_info_model.dart';
import 'package:online_events/core/models/attendees-list.dart';
import 'package:online_events/core/models/user_model.dart';
import 'package:online_events/core/models/waitlist.dart';

import '../models/event_model.dart';
import 'package:http/http.dart' as http;

abstract class Client {
  static const endpoint = 'https://old.online.ntnu.no';
  static String? accessToken;

  static void setAccessToken(String token) {
    accessToken = token;
  }

  static Future<List<EventModel>?> getEvents() async {
    List<EventModel> allEvents = [];

    // URLs for each page
    List<String> urls = [
      '$endpoint/api/v1/event/events/',
      '$endpoint/api/v1/event/events/?page=2',
      '$endpoint/api/v1/event/events/?page=3',
      '$endpoint/api/v1/event/events/?page=4',
    ];

    for (var url in urls) {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final responseBody =
            utf8.decode(response.bodyBytes, allowMalformed: true);
        final jsonResponse = jsonDecode(responseBody);

        final events = jsonResponse['results']
            .map<EventModel>((eventJson) => EventModel.fromJson(eventJson))
            .toList();

        allEvents.addAll(events);
      } else {
        print('Failed to fetch events from $url');
      }
    }

    return allEvents;
  }

  static Future<UserModel?> getUserProfile() async {
    const url = '$endpoint/api/v1/profile/';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return UserModel.fromJson(jsonResponse);
    } else {
      print('Failed to fetch user profile');
      return null;
    }
  }

  static Future<List<AttendeeInfoModel>> getAttendeeInfoModels() async {
    List<AttendeeInfoModel> allAttendees = [];

    // URLs for each page
    List<String> urls = [
      '$endpoint/api/v1/event/attendance-events/?ordering=-registration_start',
      '$endpoint/api/v1/event/attendance-events/?ordering=-registration_start&page=2',
      '$endpoint/api/v1/event/attendance-events/?ordering=-registration_start&page=3',
    ];

    for (var url in urls) {
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

        final attendees = jsonResponse['results']
            .map<AttendeeInfoModel>(
                (attendeeJson) => AttendeeInfoModel.fromJson(attendeeJson))
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

  static Future<AttendeeInfoModel?> getEventAttendanceLoggedIn(
      int eventId) async {
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

  static Future<List<AttendeesList>> getEventAttendees(int eventId) async {
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
      print('Failed to fetch event attendees from $url');
      return [];
    }
  }

  static Future<List<Waitlist>> getEventWaitlists(int eventId) async {
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
          .map<Waitlist>((json) => Waitlist.fromJson(json))
          .toList();
    } else {
      print('Failed to fetch event waitlist from $url');
      return [];
    }
  }

  static Future<List<ArticleModel>?> getArticles() async {
    const url = '$endpoint/api/v1/articles/';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final responseBody =
          utf8.decode(response.bodyBytes, allowMalformed: true);
      final jsonResponse = jsonDecode(responseBody);

      final articles = jsonResponse['results']
          .map((articleJson) {
            return ArticleModel.fromJson(articleJson);
          })
          .cast<ArticleModel>()
          .toList();

      return articles;
    } else {
      print('Failed to fetch articles');
      return null;
    }
  }
}
