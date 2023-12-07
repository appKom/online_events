import 'dart:convert';

import 'package:online_events/core/models/article_model.dart';
import 'package:online_events/core/models/attendee_info_model.dart';
import 'package:online_events/core/models/user_model.dart';

import '../models/event_model.dart';
import 'package:http/http.dart' as http;

abstract class Client {
  static const endpoint = 'https://old.online.ntnu.no';
  static String? accessToken;

  static void setAccessToken(String token) {
    accessToken = token; 
  }

  static Future<List<EventModel>?> getEvents() async {
    const url = '$endpoint/api/v1/event/events/';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final responseBody =
          utf8.decode(response.bodyBytes, allowMalformed: true);
      final jsonResponse = jsonDecode(responseBody);

      final events = jsonResponse['results']
          .map((eventJson) {
            return EventModel.fromJson(eventJson);
          })
          .cast<EventModel>()
          .toList();

      return events;
    } else {
      print('Fail');
      return [];
    }
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

  static Future<AttendeeInfoModel?> getAttendeeInfoModel() async {
    const url = '$endpoint/api/v1/attendance-events/?ordering=-registration_start/';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return AttendeeInfoModel.fromJson(jsonResponse);
    } else {
      print('Failed to fetch attendees info');
      return null;
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
