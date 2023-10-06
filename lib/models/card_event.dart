import 'package:online_events/models/list_event.dart';

class CardEventModel extends ListEventModel {
  final EventCategory category;

  CardEventModel({
    required super.name,
    required super.date,
    required super.capacity,
    required super.registered,
    required this.category,
  });
}

enum EventCategory {
  sosialt,
  bedpress,
  annet,
  utflukt,
  kurs,
  ekskursjon,
}
