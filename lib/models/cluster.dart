import 'package:skripsi_mobile/models/abstracts/has_id.dart';

class Cluster implements HasId {
  @override
  final int id;
  @override
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;

  Cluster(
      {required this.id,
      required this.name,
      required this.createdAt,
      required this.updatedAt});

  factory Cluster.fromMap(Map<String, dynamic> json) {
    return Cluster(
      id: json['id'],
      name: json['name'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
