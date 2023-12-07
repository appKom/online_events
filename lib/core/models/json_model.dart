abstract class JsonModel {
  JsonModel();
  factory JsonModel.fromJson(Map<String, dynamic> json) {
    throw UnimplementedError('fromJson must be implemented.');
  }
  Map<String, dynamic> toJson();
}
