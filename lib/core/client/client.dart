import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:online_events/core/models/article_model.dart';
import 'package:online_events/core/models/attended_events.dart';
import 'package:online_events/core/models/attendee_info_model.dart';
import 'package:online_events/core/models/attendees-list.dart';
import 'package:online_events/core/models/user_model.dart';
import 'package:online_events/core/models/waitlist.dart';

import '../models/event_model.dart';

abstract class Client {
  static const endpoint = 'https://old.online.ntnu.no';
  static String? accessToken;

  static void setAccessToken(String token) {
    accessToken = token;
  }

  static Future<List<EventModel>?> getEvents({List<int> pages = const [1, 2, 3, 4]}) async {
    List<EventModel> allEvents = [];

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

  static Future<UserModel?> getUserProfile() async {
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
      print('json response: $jsonResponse');
      return UserModel.fromJson(jsonResponse);
    } else {
      print('Failed to fetch user profile');
      return null;
    }
  }

  static Future<List<AttendedEvents>> getAttendedEvents(int userId) async {
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

  static Future<List<ArticleModel>?> getArticles() async {
    const url = '$endpoint/api/v1/articles/';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final responseBody = utf8.decode(response.bodyBytes, allowMalformed: true);
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

//   static Future<void> registerForEvent(String eventId) async {
//     final url = '$endpoint/api/v1/event/attendance-events/$eventId/register/';

//   final Map<String, dynamic> requestBody = {
//     "recaptcha": "your_recaptcha_token_here", // You might need to handle recaptcha
//     "allow_pictures": true,
//     "show_as_attending_event": true,
//     "note": ""
//   };

//   try {
//     final response = await http.post(
//       Uri.parse(url),
//       headers: {
//         "Content-Type": "application/json",
//         "Authorization": 'Bearer $accessToken',
//       },
//       body: json.encode(requestBody),
//     );

//     if (response.statusCode == 201) {
//       // Handle successful registration
//       print("Successfully registered for the event");
//     } else {
//       // Handle error
//       print("Failed to register for the event: ${response.body}");
//     }
//   } catch (e) {
//     // Handle any exceptions
//     print("Error occurred: $e");
//   }
// }
}
