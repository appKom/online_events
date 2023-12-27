class CustomFile {
  final String id;
  final String url;
  final DateTime createdAt;
  final String name;

  CustomFile({required this.id, required this.url, required this.createdAt, required this.name});

  static CustomFile fromJson(Map<String, dynamic> json) {
    String fileID = json['\$id'];
    String url = 'https://cloud.appwrite.io/v1/storage/buckets/6589b4e47f3c8840e723/files/$fileID/view?project=65706141ead327e0436a&mode=public';
    // Check if the URL is valid
    if (url == null || !Uri.parse(url).isAbsolute) {
      url =
          'https://www.kode24.no/images/79894344.jpg?imageId=79894344&x=0&y=33.333333333333&cropw=100&croph=53.524804177546&width=862&height=616'; // Replace with a valid placeholder URL
    }
    return CustomFile(
      id: json['\$id'] ?? 'default_id',
      name: json['name'] ?? '',
      url: url,
      createdAt: json['dateCreated'] != null
          ? DateTime.parse(json['dateCreated'] as String)
          : DateTime.now(),
    );
  }
}
