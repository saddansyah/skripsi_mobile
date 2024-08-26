class Flashcard {
  final int id;
  final String content;
  final DateTime createdAt;

  Flashcard({required this.id, required this.content, required this.createdAt});

  factory Flashcard.fromMap(Map<String, dynamic> json) {
    return Flashcard(
      id: json['id'],
      content: json['content'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
