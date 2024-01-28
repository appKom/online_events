import 'image_model.dart';
import 'json_model.dart';

class ArticleModel implements JsonModel {
  final String absoluteUrl;
  final String authors;
  final Author createdBy;
  final String changedDate;
  final String content;
  final String createdDate;
  final bool featured;
  final String heading;
  final String ingress;
  final String ingressShort;
  final DateTime publishedDate;
  final String slug;
  final List<String> tags;
  final String? video;
  final ImageModel? image;

  ArticleModel({
    required this.absoluteUrl,
    required this.authors,
    required this.createdBy,
    required this.changedDate,
    required this.content,
    required this.createdDate,
    required this.featured,
    required this.heading,
    required this.ingress,
    required this.ingressShort,
    required this.publishedDate,
    required this.slug,
    required this.tags,
    this.video,
    this.image,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      absoluteUrl: json['absolute_url'],
      authors: json['authors'],
      createdBy: Author.fromJson(json['created_by']),
      changedDate: json['changed_date'],
      content: json['content'],
      createdDate: json['created_date'],
      featured: json['featured'],
      heading: json['heading'],
      ingress: json['ingress'],
      ingressShort: json['ingress_short'],
      publishedDate: DateTime.parse(json['published_date']),
      slug: json['slug'],
      tags: List<String>.from(json['tags']),
      video: json['video'],
      image: json['image'] != null ? ImageModel.fromJson(json['image']) : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'absolute_url': absoluteUrl,
      'authors': authors,
      'created_by': createdBy.toJson(), // Assuming Author has toJson() method
      'changed_date': changedDate,
      'content': content,
      'created_date': createdDate,
      'featured': featured,
      'heading': heading,
      'ingress': ingress,
      'ingress_short': ingressShort,
      'published_date': publishedDate.toIso8601String(),
      'slug': slug,
      'tags': tags,
      'video': video,
      'image': image?.toJson(),
    };
  }
}

class Author implements JsonModel {
  final int id;
  final String firstName;
  final String lastName;
  final String username;

  Author({required this.id, required this.firstName, required this.lastName, required this.username});

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      username: json['username'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'username': username,
    };
  }
}
