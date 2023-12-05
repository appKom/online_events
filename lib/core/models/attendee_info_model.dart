class AttendeeInfoModel {
  final bool isAttendee;
  final bool isOnWaitlist;
  final IsEligibleForSignup isEligibleForSignup;
  final int whatPlaceIsUserOnWaitList;
  final int id;

  AttendeeInfoModel({
    required this.isAttendee,
    required this.isOnWaitlist,
    required this.isEligibleForSignup,
    required this.whatPlaceIsUserOnWaitList,
    required this.id,
  });

  Map<String, dynamic> toJson() {
    return {
      'is_attendee': isAttendee,
      'is_on_waitlist': isOnWaitlist,
      'is_eligible_for_signup': isEligibleForSignup.toJson(),
      'whatPlaceIsUserOnWaitList': whatPlaceIsUserOnWaitList,
      'id': id,
    };
  }

  factory AttendeeInfoModel.fromJson(Map<String, dynamic> json) {
    return AttendeeInfoModel(
      isAttendee: json['is_attendee'],
      isOnWaitlist: json['is_on_waitlist'],
      isEligibleForSignup: IsEligibleForSignup.fromJson(json['is_eligible_for_signup']),
      whatPlaceIsUserOnWaitList: json['whatPlaceIsUserOnWaitList'],
      id: json['id'],
    );
  }
}

class IsEligibleForSignup {
  final bool status;
  final String message;
  final int statusCode;
  final String? offset;

  IsEligibleForSignup({
    required this.status,
    required this.message,
    required this.statusCode,
    this.offset,
  });

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'status_code': statusCode,
      'offset': offset,
    };
  }

  factory IsEligibleForSignup.fromJson(Map<String, dynamic> json) {
    return IsEligibleForSignup(
      status: json['status'],
      message: json['message'],
      statusCode: json['status_code'],
      offset: json['offset'],
    );
  }
}
