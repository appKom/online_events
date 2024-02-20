class BitsModel {
  String header;
  String body;
  String imageSource;

  BitsModel({
    required this.header,
    required this.body,
    required this.imageSource,
  });

  factory BitsModel.fromJson(Map<String, dynamic> json) {
    return BitsModel(
      header: json['header'],
      body: json['body'],
      imageSource: json['imageSource'],
    );
  }

  @override
  String toString() {
    return 'UserPostModel(header: $header, body: $body, imageSource: $imageSource)';
  }
}
