class PixelUserClass {
  String userName;
  int id;
  String firstName;
  String lastName;
  String ntnuUserName;
  int year;
  

  PixelUserClass({
    required this.userName,
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.ntnuUserName,
    required this.year,
  });

  factory PixelUserClass.fromJson(Map<String, dynamic> json) {

    return PixelUserClass(
      userName: json['username'], 
      id: json['id'], 
      firstName: json['first_name'], 
      lastName: json['last_name'], 
      ntnuUserName: json['ntnuUsername'],
      year: json['year'],
    );
  }

  @override
  String toString() {
    return 'PixelUserClass(userName: $userName, id: $id, firstName: $firstName, lastName: $lastName, ntnuUserName: $ntnuUserName, year: $year)';
  }
}
