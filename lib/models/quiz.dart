class Quiz {
  final int id;
  final String question;
  // Separated by ;
  final String options;
  final String img;
  final String uniqueId;

  Quiz(
      {required this.id,
      required this.question,
      required this.options,
      required this.img,
      required this.uniqueId});

  factory Quiz.fromMap(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'],
      question: json['question'],
      options: json['options'],
      img: json['img'],
      uniqueId: json['unique_id'],
    );
  }
}

class PayloadQuiz {
  final int quizId;
  final String answer;
  final String uniqueId;

  PayloadQuiz(
      {required this.quizId, required this.answer, required this.uniqueId});

  Map<String, dynamic> toMap() {
    return {
      'answer': answer,
      'quiz_id': quizId,
      'unique_id': uniqueId,
    };
  }
}

class ResponseQuiz {
  final bool isCorrect;
  final String message;

  ResponseQuiz({required this.isCorrect, required this.message});
}

class QuizStatus {
  final DateTime createdAt;
  final DateTime nextDate;

  QuizStatus({required this.createdAt, required this.nextDate});

  factory QuizStatus.fromMap(Map<String, dynamic> json) {
    return QuizStatus(
      createdAt: DateTime.parse(json['created_at']),
      nextDate: DateTime.parse(json['next_date']),
    );
  }
}
