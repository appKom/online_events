class AttendeesList {
  final int id;
  final int event;
  final String fullName;
  final bool isVisible;
  final int yearOfStudy;
  final String fieldOfStudy;

  AttendeesList({
    required this.id,
    required this.event,
    required this.fullName,
    required this.isVisible,
    required this.yearOfStudy,
    required this.fieldOfStudy,
  });

  factory AttendeesList.fromJson(Map<String, dynamic> json) {
    return AttendeesList(
      id: json['id'],
      event: json['event'],
      fullName: json['full_name'],
      isVisible: json['is_visible'],
      yearOfStudy: json['year_of_study'],
      fieldOfStudy: json['field_of_study'],
    );
  }
}