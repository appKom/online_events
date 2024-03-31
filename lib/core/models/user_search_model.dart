class UserSearchModel {
  final int id;
  final String firstName;
  final String lastName;
  final String username;
  final String? nickname;
  final int year;
  final String? bio;
  final bool? isMember;
  final String image;

  UserSearchModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.year,
    this.nickname,
    this.bio,
    this.isMember,
    required this.image,
  });

  factory UserSearchModel.fromJson(Map<String, dynamic> json) {
    return UserSearchModel(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      username: json['username'],
      nickname: json['nickname'],
      year: json['year'],
      bio: json['bio'],
      isMember: json['is_member'],
      image: json['image'],
    );
  }
}
