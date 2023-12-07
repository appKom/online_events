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
  final bool hasFeedback;
  final bool hasExtras;
  final bool hasReservation;
  final List<dynamic> extras; // Replace dynamic with specific type if needed
  final dynamic payment; // Replace dynamic with specific type if needed
  final dynamic feedback; // Replace dynamic with specific type if needed
  final bool hasPostponedRegistration;
  final bool isMarked;
  final bool isSuspended;
  final Eligibility isEligibleForSignup;
  final bool isAttendee;
  final bool isOnWaitlist;
  final int whatPlaceIsUserOnWaitList;

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
    required this.hasFeedback,
    required this.hasExtras,
    required this.hasReservation,
    required this.extras,
    this.payment,
    this.feedback,
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
      id: json['id'],
      maxCapacity: json['max_capacity'],
      waitlist: json['waitlist'],
      guestAttendance: json['guest_attendance'],
      registrationStart: DateTime.parse(json['registration_start']),
      registrationEnd: DateTime.parse(json['registration_end']),
      unattendDeadline: DateTime.parse(json['unattend_deadline']),
      automaticallySetMarks: json['automatically_set_marks'],
      ruleBundles: List<int>.from(json['rule_bundles']),
      numberOnWaitlist: json['number_on_waitlist'],
      numberOfSeatsTaken: json['number_of_seats_taken'],
      hasFeedback: json['has_feedback'],
      hasExtras: json['has_extras'],
      hasReservation: json['has_reservation'],
      extras: json['extras'], // May need further parsing based on actual type
      payment: json['payment'],
      feedback: json['feedback'],
      hasPostponedRegistration: json['has_postponed_registration'],
      isMarked: json['is_marked'],
      isSuspended: json['is_suspended'],
      isEligibleForSignup: Eligibility.fromJson(json['is_eligible_for_signup']),
      isAttendee: json['is_attendee'],
      isOnWaitlist: json['is_on_waitlist'],
      whatPlaceIsUserOnWaitList: json['what_place_is_user_on_wait_list'],
    );
  }
}

class Eligibility {
  final bool status;
  final String message;
  final int statusCode;
  final dynamic offset; // Replace dynamic with specific type if needed

  Eligibility({
    required this.status,
    required this.message,
    required this.statusCode,
    this.offset,
  });

  factory Eligibility.fromJson(Map<String, dynamic> json) {
    return Eligibility(
      status: json['status'],
      message: json['message'],
      statusCode: json['status_code'],
      offset: json['offset'],
    );
  }
}