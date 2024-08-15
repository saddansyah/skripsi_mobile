class Achievement {
  Achievement(
      {required this.id,
      required this.name,
      required this.description,
      required this.img});

  final num id;
  final String name;
  final String description;
  final String img;

  factory Achievement.fromMap(Map<String, dynamic> json) {
    final data = json['data'][0];

    return Achievement(
      id: data['id'],
      name: data['name'],
      description: data['description'],
      img: data['img'],
    );
  }
}
