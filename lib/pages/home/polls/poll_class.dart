class PollClass {
  final String id;
  String question;
  List<dynamic> choices;
  List<dynamic> votes;
  final DateTime createdAt;

  PollClass({
    required this.id,
    required this.question,
    required this.choices,
    required this.votes,
    required this.createdAt,
  });

  factory PollClass.fromJson(Map<String, dynamic> json) {
    String fileID = json['\$id'] as String;

    DateTime parsedCreatedAt;
    if (json['\$createdAt'] != null) {
      parsedCreatedAt = DateTime.parse(json['\$createdAt']);
    } else {
      parsedCreatedAt = DateTime.now();
    }

    return PollClass(
      id: fileID,
      question: json['question'] ?? '',
      choices: json['choices'] ?? [],
      votes: json['votes'] ?? [],
      createdAt: parsedCreatedAt,
    );
  }

  @override
  String toString() {
    return 'PollClass(question: $question, choices: $choices, votes: $votes)';
  }
}
