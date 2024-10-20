/// Info about user's attendance at an event.
/// Is the event paid, has the user paid for the event, did the user show up, etc.
class EventAttendanceModel {
  final int eventId;
  final bool attended;
  final String timestamp;
  final bool isPaidEvent;
  final bool hasPaidForEvent;

  EventAttendanceModel({
    required this.eventId,
    required this.attended,
    required this.timestamp,
    required this.isPaidEvent,
    required this.hasPaidForEvent,
  });

  factory EventAttendanceModel.fromJson(Map<String, dynamic> json) {
    return EventAttendanceModel(
      eventId: json['event'],
      attended: json['attended'],
      timestamp: json['timestamp'],
      isPaidEvent: json['paid'],
      hasPaidForEvent: json['has_paid'],
    );
  }

  @override
  bool operator ==(Object other) {
    // if (identical(this, other)) return true;
    if (other is! EventAttendanceModel) return false;
    // if (other.runtimeType != runtimeType) return false;
    return eventId == other.eventId;
  }

  @override
  int get hashCode => eventId.hashCode;
}
