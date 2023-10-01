/// Model for events visible in the ListView on the initial page.
class ListEventModel {
  /// Event name
  final String name;

  /// Event date
  final DateTime date;

  /// Event capacity. If capacity is set to null, it will be interpreted as infinite capacity.
  final int? capacity;

  /// Number of people registered for this event.
  final int registered;

  ListEventModel({
    required this.name,
    required this.date,
    required this.capacity,
    required this.registered,
  });
}