class Achievement {
  Achievement( 
      {required this.id,
      required this.name,
      required this.description,
      required this.img, 
      required this.createdAt,
      });

  final num id;
  final String name;
  final String description;
  final String img;
  final DateTime createdAt;

  factory Achievement.fromMap(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      img: json['img'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
