class AttendeeInfoModel {
  final int id;
  final int maxCapacity;
  final bool waitlist;
  final bool guestAttendance;
  final DateTime registrationStart;
  final DateTime registrationEnd;
  final DateTime unattendDeadline;
  final bool automaticallySetMarks;
  final List<int> ruleBundles;
  final int numberOnWaitlist;
  final int numberOfSeatsTaken;
  final String hasPostponedRegistration;
  final bool isMarked;
  final bool isSuspended;
  final Eligibility isEligibleForSignup;
  final bool isAttendee;
  final bool isOnWaitlist;
  final int whatPlaceIsUserOnWaitList;

  factory AttendeeInfoModel.withDefaults() {
    return AttendeeInfoModel(
      id: -1, // Indicates an invalid or default ID
      maxCapacity: 0,
      waitlist: false,
      guestAttendance: false,
      registrationStart: DateTime.now(),
      registrationEnd: DateTime.now()
          .add(const Duration(days: 30)), // Default end date 30 days from now
      unattendDeadline: DateTime.now()
          .add(const Duration(days: 10)), // Default deadline 10 days from now
      automaticallySetMarks: false,
      ruleBundles: [],
      numberOnWaitlist: 0,
      numberOfSeatsTaken: 0,
      hasPostponedRegistration: '',
      isMarked: false,
      isSuspended: false,
      isEligibleForSignup: Eligibility.withDefaults(),
      isAttendee: false,
      isOnWaitlist: false,
      whatPlaceIsUserOnWaitList: 0,
    );
  }

  AttendeeInfoModel({
    required this.id,
    required this.maxCapacity,
    required this.waitlist,
    required this.guestAttendance,
    required this.registrationStart,
    required this.registrationEnd,
    required this.unattendDeadline,
    required this.automaticallySetMarks,
    required this.ruleBundles,
    required this.numberOnWaitlist,
    required this.numberOfSeatsTaken,
    required this.hasPostponedRegistration,
    required this.isMarked,
    required this.isSuspended,
    required this.isEligibleForSignup,
    required this.isAttendee,
    required this.isOnWaitlist,
    required this.whatPlaceIsUserOnWaitList,
  });

  factory AttendeeInfoModel.fromJson(Map<String, dynamic> json) {
    return AttendeeInfoModel(
      id: json['id'] ?? 0,
      maxCapacity: json['max_capacity'] ?? 0,
      waitlist: json['waitlist'] ?? false,
      guestAttendance: json['guest_attendance'] ?? false,
      registrationStart: json['registration_start'] != null
          ? DateTime.parse(json['registration_start'])
          : DateTime.now(),
      registrationEnd: json['registration_end'] != null
          ? DateTime.parse(json['registration_end'])
          : DateTime.now(),
      unattendDeadline: json['unattend_deadline'] != null
          ? DateTime.parse(json['unattend_deadline'])
          : DateTime.now(),
      automaticallySetMarks: json['automatically_set_marks'] ?? false,
      ruleBundles: json['rule_bundles'] != null
          ? List<int>.from(json['rule_bundles'])
          : [],
      numberOnWaitlist: json['number_on_waitlist'] ?? 0,
      numberOfSeatsTaken: json['number_of_seats_taken'] ?? 0,
      hasPostponedRegistration: json['has_postponed_registration'] ?? false,
      isMarked: json['is_marked'] ?? false,
      isSuspended: json['is_suspended'] ?? false,
      isEligibleForSignup:
          Eligibility.fromJson(json['is_eligible_for_signup'] ?? {}),
      isAttendee: json['is_attendee'] ?? false,
      isOnWaitlist: json['is_on_waitlist'] ?? false,
      whatPlaceIsUserOnWaitList: json['what_place_is_user_on_wait_list'] ?? 0,
    );
  }
}

class Eligibility {
  final bool status;
  final String message;
  final int statusCode;
  final dynamic offset; // Replace dynamic with specific type if needed

  factory Eligibility.withDefaults() {
    return Eligibility(
      status: false,
      message: 'Dette er ikke et påmeldingsarrangement',
      statusCode: 6969,
      offset: null, // Assuming null is a valid default
    );
  }

  Eligibility({
    required this.status,
    required this.message,
    required this.statusCode,
    this.offset,
  });

  factory Eligibility.fromJson(Map<String, dynamic> json) {
    return Eligibility(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      statusCode: json['status_code'] ?? 0,
      offset: json['offset'],
    );
  }
}
