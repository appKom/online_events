import 'package:online_events/core/models/json_model.dart';

class ImageModel implements JsonModel {
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
  final String? photographer;
  final String preset;
  final String presetDisplay;

  ImageModel({
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

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'timestamp': timestamp,
      'description': description,
      'thumb': thumb,
      'original': original,
      'wide': wide,
      'lg': lg,
      'md': md,
      'sm': sm,
      'xs': xs,
      'tags': tags,
      'photographer': photographer,
      'preset': preset,
      'preset_display': presetDisplay,
    };
  }

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
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
