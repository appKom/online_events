import 'dart:convert';

import '../models/event_model.dart';
import 'package:http/http.dart' as http;

abstract class Client {
  static const endpoint = 'https://old.online.ntnu.no';

  static Future<List<EventModel>?> getEvents() async {
    const url = '$endpoint/api/v1/event/events/';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);

      final events = jsonResponse['results'].map((eventJson) {
        // print(eventJson);
        return EventModel.fromJson(eventJson);
      }).toList();

      print(events[0]);
      // print(response.body);
    } else {
      print('Fail');
    }

    return [];
  }
}
