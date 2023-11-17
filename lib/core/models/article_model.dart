class ApiResponse {
  final int count;
  final String? next;
  final String? previous;
  final List<ArticleModel> results;

  ApiResponse({required this.count, this.next, this.previous, required this.results});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    var list = json['results'] as List;
    List<ArticleModel> articlesList = list.map((i) => ArticleModel.fromJson(i)).toList();

    return ApiResponse(
      count: json['count'],
      next: json['next'],
      previous: json['previous'],
      results: articlesList,
    );
  }
}

class ArticleModel {
  final String absoluteUrl;
  final String authors;
  final Author createdBy;
  final String changedDate;
  final String content;
  final DateTime createdDate;
  final bool featured;
  final String heading;
  final String ingress;
  final String ingressShort;
  final DateTime publishedDate;
  final String slug;
  final List<String> tags;
  final String? video;
  final ImageData? image;

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
      createdDate: DateTime.parse(json['created_date']),
      featured: json['featured'],
      heading: json['heading'],
      ingress: json['ingress'],
      ingressShort: json['ingress_short'],
      publishedDate: DateTime.parse(json['published_date']),
      slug: json['slug'],
      tags: List<String>.from(json['tags']),
      video: json['video'],
      image: json['image'] != null ? ImageData.fromJson(json['image']) : null,
    );
  }
}

class Author {
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
}

class ImageData {
  final int id;
  final String name;
  final String timestamp;
  final String description;
  final String thumb;
  final String original;
  final String wide;
  final String lg;
  final String md;
  final String sm;
  final String xs;
  final List<String> tags;
  final String photographer;
  final String preset;
  final String presetDisplay;

  ImageData({
    required this.id,
    required this.name,
    required this.timestamp,
    required this.description,
    required this.thumb,
    required this.original,
    required this.wide,
    required this.lg,
    required this.md,
    required this.sm,
    required this.xs,
    required this.tags,
    required this.photographer,
    required this.preset,
    required this.presetDisplay,
  });

  factory ImageData.fromJson(Map<String, dynamic> json) {
    return ImageData(
      id: json['id'],
      name: json['name'],
      timestamp: json['timestamp'],
      description: json['description'],
      thumb: json['thumb'],
      original: json['original'],
      wide: json['wide'],
      lg: json['lg'],
      md: json['md'],
      sm: json['sm'],
      xs: json['xs'],
      tags: List<String>.from(json['tags']),
      photographer: json['photographer'],
      preset: json['preset'],
      presetDisplay: json['preset_display'],
    );
  }
}
