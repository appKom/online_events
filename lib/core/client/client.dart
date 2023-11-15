import 'dart:convert';

import '../models/event_model.dart';
import 'package:http/http.dart' as http;

abstract class Client {
  static const endpoint = 'https://old.online.ntnu.no';

  static Future<List<EventModel>?> getEvents() async {
    const url = '$endpoint/api/v1/event/events/';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final responseBody = utf8.decode(response.bodyBytes, allowMalformed: true);
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
}
