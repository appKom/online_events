import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:online/core/models/event_model.dart';

import '../../services/authenticator.dart';
import 'client.dart';

int eventIdPage = 1;
bool fetchedAllCalendarEvents = false;

abstract class CalendarClient {
  static const endpoint = 'https://old.online.ntnu.no';

  static final ValueNotifier<List<int?>?> calendarIdCache = ValueNotifier<List<int?>?>(null);
  static final ValueNotifier<List<EventModel>?> calendarEventCache = ValueNotifier<List<EventModel>?>(null);

  static Future fetchEventsForCalendarCache({
    required int userId,
    required List<int> eventIds,
  }) async {
    final calendarIds = calendarIdCache.value;
    if (calendarIds == null || calendarIds.isEmpty) {
      print('No calendar IDs found in cache');
      return;
    }

    List<Future<List<EventModel>>> fetchFutures = [];

    fetchFutures = [getEventsWithIds(eventIds: eventIds)];

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

    if (jsonResults['detail'] == 'Ugyldig side') {
      fetchedAllCalendarEvents = true;
      return;
    }

    if (response.statusCode != 200) {
      print('Error fetching event IDs');
      return;
    }

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

    eventIdPage += 1;
    await fetchEventsForCalendarCache(userId: userId, eventIds: results);
  }

  static Future<List<EventModel>> getEventsWithIds({List<int> eventIds = const []}) async {
    Map<int, EventModel> eventMap = {};

    var futures = eventIds.map((eventId) => Client.getEventWithId(eventId));
    final results = await Future.wait(futures);

    for (var event in results) {
      if (event != null) {
        eventMap.putIfAbsent(event.id, () => event);
      }
    }

    return results.whereType<EventModel>().toList();
  }
}
