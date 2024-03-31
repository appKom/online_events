import 'image_model.dart';

class HobbyModel {
  final int id;
  final String title;
  final String? description;
  final String? readMoreLink;
  final ImageModel? image;
  final int? priority;
  final bool active;

  HobbyModel({
    required this.id,
    required this.title,
    this.description,
    this.readMoreLink,
    this.image,
    this.priority,
    required this.active,
  });

  factory HobbyModel.fromJson(Map<String, dynamic> json) {
    return HobbyModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      readMoreLink: json['read_more_link'],
      image: json['image'] != null ? ImageModel.fromJson(json['image']) : null,
      priority: json['priority'],
      active: json['active'],
    );
  }
}
