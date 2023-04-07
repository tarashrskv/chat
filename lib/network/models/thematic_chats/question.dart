class Question {
  final String question;

  Question({required this.question});

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      question: json['question'],
    );
  }
}