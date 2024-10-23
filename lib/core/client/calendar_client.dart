import 'package:online/core/models/event_model.dart';
import 'package:http/http.dart' as http;
import '../../services/authenticator.dart';
import '../models/event_attendance_model.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';

abstract class CalendarClient {
  static const endpoint = 'https://old.online.ntnu.no';

  final accessToken = Authenticator.credentials?.accessToken;

  int eventIdPage = 1;

  static final ValueNotifier<List<int?>?> calendarIdCache = ValueNotifier<List<int?>?>(null);

  Future getCalendarEventIds({
    required int userId,
  }) async {
    final url = '$endpoint/api/v1/event/attendees/?page=$eventIdPage&ordering=-id&user=$userId';

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
  }
}
