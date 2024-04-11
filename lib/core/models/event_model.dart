import 'image_model.dart';

class EventModel {
  final int id;
  final String title;
  final String slug;
  final String ingress;
  final String ingressShort;
  final String description;
  final String startDate;
  final String endDate;
  final String location;
  final int eventType;
  final String eventTypeDisplay;
  final int organizer;
  final Author? author;
  final List<ImageModel> images;
  final List<String> companies;
  final bool isAttendanceEvent;
  final int? maxCapacity;
  final bool? waitlist;
  final int? numberOfSeatsTaken;

  EventModel({
    required this.id,
    required this.title,
    required this.slug,
    required this.ingress,
    required this.ingressShort,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.location,
    required this.eventType,
    required this.eventTypeDisplay,
    required this.organizer,
    required this.images,
    required this.companies,
    required this.isAttendanceEvent,
    this.maxCapacity,
    this.waitlist,
    this.numberOfSeatsTaken,
    this.author,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      slug: json['slug'] ?? '',
      ingress: json['ingress'] ?? '',
      ingressShort: json['ingress_short'] ?? '',
      description: json['description'] ?? '',
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      location: json['location'] ?? '',
      eventType: json['event_type'] ?? 0,
      eventTypeDisplay: json['event_type_display'] ?? '',
      organizer: json['organizer'] ?? 0,
      author: json['author'] != null ? Author.fromJson(json['author']) : null,
      images: (json['images'] as List<dynamic>? ?? []).map((imageJson) => ImageModel.fromJson(imageJson)).toList(),
      companies: List<String>.from(json['companies'] ?? []),
      isAttendanceEvent: json['is_attendance_event'] ?? false,
      maxCapacity: json['max_capacity'],
      waitlist: json['waitlist'],
      numberOfSeatsTaken: json['number_of_seats_taken'],
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! EventModel) return false;
    if (other.runtimeType != runtimeType) return false;
    return id == other.id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'EventModel: { id: $id, title: $title, startDate: $startDate, endDate: $endDate, location: $location,}';
  }
}

class Author {
  final int id;
  final String firstName;
  final String lastName;
  final String userName;

  Author({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.userName,
  });

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      id: json['id'] ?? 69,
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      userName: json['userName'] ?? '',
    );
  }
}
