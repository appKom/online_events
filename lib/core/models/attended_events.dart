class AttendedEvents {
  final int id;
  final int event;
  final UserInfo user;
  final DateTime timestamp;


  AttendedEvents({
    required this.id,
    required this.event,
    required this.timestamp,
    required this.user,
  });

  factory AttendedEvents.fromJson(Map<String, dynamic> json) {
    return AttendedEvents(
      id: json['id'] ?? 0,
      event: json['event'] ?? 0,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
      user:
          UserInfo.fromJson(json['user'] ?? {}),
    );
  }
}

class UserInfo {
  final int id;
  final String firstName;
  final int lastName;
  final String username; 

  UserInfo({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['id'] ?? 0,
      firstName: json['firstName'] ?? '',
      lastName: json['status_code'] ?? 0,
      username: json['username'] ?? '',
    );
  }
}
