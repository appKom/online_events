class CustomFile {
  final String id;
  final String url;
  final DateTime createdAt;
  final String name;

  CustomFile(
      {required this.id,
      required this.url,
      required this.createdAt,
      required this.name});

  static CustomFile fromJson(Map<String, dynamic> json) {
    String fileID = json['\$id'] as String;
    String url =
        'https://cloud.appwrite.io/v1/storage/buckets/6589b4e47f3c8840e723/files/$fileID/view?project=65706141ead327e0436a&mode=public';

    DateTime parsedCreatedAt;
    if (json['\$createdAt'] != null) {
      parsedCreatedAt = DateTime.parse(json['\$createdAt']);
    } else {
      parsedCreatedAt =
          DateTime.now(); // Default to current time if not present
    }

    return CustomFile(
      id: fileID,
      name: json['name'] ?? '',
      url: url,
      createdAt: parsedCreatedAt,
    );
  }
}

