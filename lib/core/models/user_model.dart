class UserModel {
  final int id;
  final String firstName;
  final String lastName;
  final String username;
  final String? nickname;
  final String? ntnuUsername;
  final int year;
  final String email;
  final String? onlineMail;
  final String? phoneNumber;
  final String? address;
  final String? website;
  final String? github;
  final String? linkedin;
  final List<dynamic>? positions;
  final List<dynamic>? specialPositions;
  final String? rfid;
  final int? fieldOfStudy;
  final DateTime? startedDate;
  final bool? compiled;
  final bool? infomail;
  final bool? jobmail;
  final String? zipCode;
  final String? allergies;
  final bool? markRulesAccepted;
  final String? gender;
  final String? bio;
  final int? saldo;
  final bool? isCommittee;
  final bool? isMember;
  final String? image;
  final bool? hasExpiringMembership;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    this.nickname,
    this.ntnuUsername,
    required this.year,
    required this.email,
    this.onlineMail,
    this.phoneNumber,
    this.address,
    this.website,
    this.github,
    this.linkedin,
    this.positions,
    this.specialPositions,
    this.rfid,
    this.fieldOfStudy,
    this.startedDate,
    this.compiled,
    this.infomail,
    this.jobmail,
    this.zipCode,
    this.allergies,
    this.markRulesAccepted,
    this.gender,
    this.bio,
    this.saldo,
    this.isCommittee,
    this.isMember,
    this.image,
    this.hasExpiringMembership,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      username: json['username'],
      nickname: json['nickname'],
      ntnuUsername: json['ntnu_username'],
      year: json['year'],
      email: json['email'],
      onlineMail: json['online_mail'],
      phoneNumber: json['phone_number'],
      address: json['address'],
      website: json['website'],
      github: json['github'],
      linkedin: json['linkedin'],
      positions: json['positions'] ?? [],
      specialPositions: json['special_positions'] ?? [],
      rfid: json['rfid'],
      fieldOfStudy: json['field_of_study'],
      startedDate: DateTime.parse(json['started_date']),
      compiled: json['compiled'],
      infomail: json['infomail'],
      jobmail: json['jobmail'],
      zipCode: json['zip_code'],
      allergies: json['allergies'],
      markRulesAccepted: json['mark_rules_accepted'],
      gender: json['gender'],
      bio: json['bio'],
      saldo: json['saldo'],
      isCommittee: json['is_committee'],
      isMember: json['is_member'],
      image: json['image'],
      hasExpiringMembership: json['has_expiring_membership'],
    );
  }
}
