import 'attendee_info_model.dart';
import 'image_model.dart';
import 'json_model.dart';

class EventModel implements JsonModel {
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
  final String? author;
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

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'slug': slug,
      'ingress': ingress,
      'ingress_short': ingressShort,
      'description': description,
      'start_date': startDate,
      'end_date': endDate,
      'location': location,
      'event_type': eventType,
      'event_type_display': eventTypeDisplay,
      'organizer': organizer,
      'author': author,
      'images': images.map((image) => image.toJson()).toList(),
      'companies': companies,
      'is_attendance_event': isAttendanceEvent,
      'max_capacity': maxCapacity,
      'waitlist': waitlist,
      'number_of_seats_taken': numberOfSeatsTaken,
    };
  }

  factory EventModel.fromJson(Map<String, dynamic> json) {
    AttendeeInfoModel? attendeeInfo;


    if (json['attendee_info'] != null) {
      AttendeeInfoModel tempAttendeeInfo = AttendeeInfoModel.fromJson(json['attendee_info']);
      if (tempAttendeeInfo.id == json['id']) {
        attendeeInfo = tempAttendeeInfo;
      }
    }


    return EventModel(
      id: json['id'],
      title: json['title'],
      slug: json['slug'],
      ingress: json['ingress'],
      ingressShort: json['ingress_short'],
      description: json['description'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      location: json['location'],
      eventType: json['event_type'],
      eventTypeDisplay: json['event_type_display'],
      organizer: json['organizer'],
      author: json['author'],
      images: (json['images'] as List<dynamic>).map((imageJson) => ImageModel.fromJson(imageJson)).toList(),
      companies: List<String>.from(json['companies']),
      isAttendanceEvent: json['is_attendance_event'],
      maxCapacity: json['max_capacity'],
      waitlist: json['waitlist'],
      numberOfSeatsTaken: json['number_of_seats_taken'],
    );
  }

  @override
  String toString() {
    return 'EventModel: { id: $id, title: $title, startDate: $startDate, endDate: $endDate, location: $location,}';
  }
}
