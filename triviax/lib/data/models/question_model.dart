class Question {
  final String id;
  final String category;
  final String type;
  final String difficulty;
  final String question;
  final String correctAnswer;
  final List<String> incorrectAnswers;
  final List<String> allAnswers;

  Question({
    required this.id,
    required this.category,
    required this.type,
    required this.difficulty,
    required this.question,
    required this.correctAnswer,
    required this.incorrectAnswers,
  }) : allAnswers = List<String>.from(incorrectAnswers)..add(correctAnswer)..shuffle();

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] ?? '',
      category: json['category'] ?? '',
      type: json['type'] ?? '',
      difficulty: json['difficulty'] ?? '',
      question: json['question']['text'] ?? '',
      correctAnswer: json['correctAnswer'] ?? '',
      incorrectAnswers: List<String>.from(json['incorrectAnswers'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'type': type,
      'difficulty': difficulty,
      'question': {'text': question},
      'correctAnswer': correctAnswer,
      'incorrectAnswers': incorrectAnswers,
    };
  }
}
