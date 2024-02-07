import '/core/models/json_model.dart';

class ApiResponse<T extends JsonModel> {
  final int count;
  final String? next;
  final String? previous;
  final List<T> results;

  ApiResponse({required this.count, this.next, this.previous, required this.results});

  factory ApiResponse.fromJson(Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJson) {
    var list = json['results'] as List;
    List<T> articlesList = list.map((i) => fromJson(i)).toList();

    return ApiResponse(
      count: json['count'],
      next: json['next'],
      previous: json['previous'],
      results: articlesList,
    );
  }
}
