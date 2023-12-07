class ListParticipantModel {
  /// Participant name
  final String name;

  /// Participant Year
  final int year;

  /// When was the participant registered
  final int registered;

  ListParticipantModel({
    required this.name,
    required this.year,
    required this.registered,
  });
}