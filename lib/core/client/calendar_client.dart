import 'package:online/core/models/event_model.dart';
import 'package:http/http.dart' as http;
import '../../services/authenticator.dart';
import '../models/event_attendance_model.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';

int eventIdPage = 1;

abstract class CalendarClient {
  static const endpoint = 'https://old.online.ntnu.no';

  static final ValueNotifier<List<int?>?> calendarIdCache = ValueNotifier<List<int?>?>(null);
  static final ValueNotifier<List<EventModel>?> calendarEventCache = ValueNotifier<List<EventModel>?>(null);

  static Future fetchEventsForCalendarCache({
    required int userId,
  }) async {
    final calendarIds = calendarIdCache.value;
    if (calendarIds == null || calendarIds.isEmpty) {
      print('No calendar IDs found in cache');
      return;
    }

    Future<List<EventModel>> fetchEventsForCalendarId(int calendarId) async {
      final url = '$endpoint/api/v1/event/events/$calendarId';
      final accessToken = Authenticator.credentials?.accessToken;
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      final results = <EventModel>[];

      if (response.statusCode == 200) {
        final body = utf8.decode(response.bodyBytes, allowMalformed: true);
        final jsonResults = jsonDecode(body);

        if (jsonResults != null) {
          final event = EventModel.fromJson(jsonResults);
          results.add(event);
        }
      } else {
        print('Error fetching events for calendarId: $calendarId');
      }

      return results;
    }

    List<Future<List<EventModel>>> fetchFutures = [];

    for (int? calendarId in calendarIds) {
      if (calendarId != null) {
        fetchFutures.add(fetchEventsForCalendarId(calendarId));
      }
    }

    final allResults = await Future.wait(fetchFutures);
    final allFetchedEvents = allResults.expand((events) => events).toList();

    if (calendarEventCache.value != null) {
      calendarEventCache.value = [...calendarEventCache.value!, ...allFetchedEvents];
    } else {
      calendarEventCache.value = allFetchedEvents;
    }
  }

  static Future getCalendarEventIds({
    required int userId,
    required int eventIdPage,
  }) async {
    final url = '$endpoint/api/v1/event/attendees/?page=$eventIdPage&ordering=-id&user=$userId';
    final accessToken = Authenticator.credentials?.accessToken;

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    final results = <int>[];

    final body = utf8.decode(response.bodyBytes, allowMalformed: true);
    final jsonResults = jsonDecode(body);

    if (jsonResults != null) {
      for (var result in jsonResults['results']) {
        results.add(result['event']);
      }
    }

    if (calendarIdCache.value != null) {
      calendarIdCache.value = [...calendarIdCache.value!, ...results];
    } else {
      calendarIdCache.value = results;
    }

    if (jsonResults['next'] != null) {
      eventIdPage++;
      await fetchEventsForCalendarCache(userId: userId);
    }
  }
}
