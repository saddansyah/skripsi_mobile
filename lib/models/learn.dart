class Learn {
  final int id;
  final String title;
  final String excerpt;
  final String content;
  final String img;
  final String category;
  final DateTime createdAt;
  final DateTime updatedAt;

  Learn(
      {required this.id,
      required this.title,
      required this.excerpt,
      required this.content,
      required this.img,
      required this.category,
      required this.createdAt,
      required this.updatedAt});

  factory Learn.fromMap(Map<String, dynamic> json) {
    return Learn(
      id: json['id'],
      title: json['title'],
      excerpt: json['excerpt'],
      content: json['content'],
      img: json['img'],
      category: json['category'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
