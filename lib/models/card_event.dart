import '/models/list_event.dart';

class CardEventModel extends ListEventModel {
  final EventCategory category;

  CardEventModel({
    required super.imageSource,
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
