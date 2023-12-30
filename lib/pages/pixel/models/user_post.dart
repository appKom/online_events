class UserPostModel {
  final String id;
  String imageName;
  int numberOfLikes;
  String username;
  String firstName;
  String lastName;
  String description;
  String imageLink;
  String postCreated;
  final DateTime createdAt;
  List<String> likedBy;
  List<String> comments;
  

  UserPostModel({
    required this.id,
    required this.imageName,
    required this.numberOfLikes,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.description,
    required this.imageLink,
    required this.postCreated,
    required this.createdAt,
    required this.likedBy,
    required this.comments,
  });

  factory UserPostModel.fromJson(Map<String, dynamic> json) {
    String fileID = json['\$id'] as String;
    List<String> likedBy = List<String>.from(json['liked_by'] ?? []);
    List<String> comments = List<String>.from(json['comments'] ?? []);

    DateTime parsedCreatedAt;
    if (json['\$createdAt'] != null) {
      parsedCreatedAt = DateTime.parse(json['\$createdAt']);
    } else {
      parsedCreatedAt =
          DateTime.now(); 
    }

    return UserPostModel(
      id: fileID,
      imageName: json['image_name'], 
      numberOfLikes: json['number_of_likes'], 
      username: json['username'],
      firstName: json['first_name'], 
      lastName: json['last_name'], 
      description: json['description'],
      imageLink: json['image_link'], 
      postCreated: json['post_created'], 
      createdAt: parsedCreatedAt,
      likedBy: likedBy,
      comments: comments,
    );
  }

  @override
  String toString() {
    return 'UserPostModel(imageName: $imageName, numberOfLikes: $numberOfLikes, username: $username, firstName: $firstName, lastName: $lastName, description: $description, imageLink: $imageLink, postCreated: $postCreated)';
  }
}
