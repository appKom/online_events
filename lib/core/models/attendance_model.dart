class AttendanceResponse {
  final int count;
  final String? next;
  final String? previous;
  final List<AttendanceModel> results;

  AttendanceResponse({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory AttendanceResponse.fromJson(Map<String, dynamic> json) {
    var list = json['results'] as List;
    List<AttendanceModel> eventList = list.map((i) => AttendanceModel.fromJson(i)).toList();
    return AttendanceResponse(
      count: json['count'],
      next: json['next'],
      previous: json['previous'],
      results: eventList,
    );
  }
}

class AttendanceModel {
  final int id;
  final int maxCapacity;
  final bool waitlist;
  final bool guestAttendance;
  final String registrationStart;
  final String registrationEnd;
  final String unattendDeadline;
  final bool automaticallySetMarks;
  final List<dynamic> ruleBundles; // Consider creating a model if structure is known
  final int numberOnWaitlist;
  final int numberOfSeatsTaken;
  final bool hasFeedback;
  final bool hasExtras;
  final bool hasReservation;
  final List<dynamic> extras; // Consider creating a model if structure is known
  final dynamic payment; // Replace with specific type if known
  final dynamic feedback; // Replace with specific type if known
  final bool hasPostponedRegistration;
  final bool isMarked;
  final bool isSuspended;
  final EligibilityForSignup isEligibleForSignup;
  final bool isAttendee;
  final bool isOnWaitlist;
  final int whatPlaceIsUserOnWaitList;

  AttendanceModel({
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

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      id: json['id'],
      maxCapacity: json['max_capacity'],
      waitlist: json['waitlist'],
      guestAttendance: json['guest_attendance'],
      registrationStart: json['registration_start'],
      registrationEnd: json['registration_end'],
      unattendDeadline: json['unattend_deadline'],
      automaticallySetMarks: json['automatically_set_marks'],
      ruleBundles: json['rule_bundles'],
      numberOnWaitlist: json['number_on_waitlist'],
      numberOfSeatsTaken: json['number_of_seats_taken'],
      hasFeedback: json['has_feedback'],
      hasExtras: json['has_extras'],
      hasReservation: json['has_reservation'],
      extras: json['extras'],
      payment: json['payment'],
      feedback: json['feedback'],
      hasPostponedRegistration: json['has_postponed_registration'],
      isMarked: json['is_marked'],
      isSuspended: json['is_suspended'],
      isEligibleForSignup: EligibilityForSignup.fromJson(json['is_eligible_for_signup']),
      isAttendee: json['is_attendee'],
      isOnWaitlist: json['is_on_waitlist'],
      whatPlaceIsUserOnWaitList: json['what_place_is_user_on_wait_list'],
    );
  }
}

class EligibilityForSignup {
  final bool status;
  final String message;
  final int statusCode;
  final dynamic offset; // Replace with specific type if known

  EligibilityForSignup({
    required this.status,
    required this.message,
    required this.statusCode,
    this.offset,
  });

  factory EligibilityForSignup.fromJson(Map<String, dynamic> json) {
    return EligibilityForSignup(
      status: json['status'],
      message: json['message'],
      statusCode: json['status_code'],
      offset: json['offset'],
    );
  }
}