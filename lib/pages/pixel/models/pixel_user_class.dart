class PixelUserClass {
  String userName;
  int id;
  String firstName;
  String lastName;
  String ntnuUserName;
  int year;
  String? biography;
  

  PixelUserClass({
    required this.userName,
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.ntnuUserName,
    required this.year,
    this.biography,
  });

  factory PixelUserClass.fromJson(Map<String, dynamic> json) {

    return PixelUserClass(
      userName: json['username'] ?? '', 
      id: json['id'] ?? 0, 
      firstName: json['first_name'] ?? '', 
      lastName: json['last_name'] ?? '', 
      ntnuUserName: json['ntnuUsername'] ?? '',
      year: json['year'] ?? '',
      biography: json['biography'] ?? '',
    );
  }

  @override
  String toString() {
    return 'PixelUserClass(userName: $userName, id: $id, firstName: $firstName, lastName: $lastName, ntnuUserName: $ntnuUserName, year: $year, biography: $biography)';
  }
}
