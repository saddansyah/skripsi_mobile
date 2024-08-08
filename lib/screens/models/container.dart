import 'package:skripsi_mobile/utils/constants/enums.dart';

class Container {
  final int id;
  final String name;
  final ContainerType type;
  final int rating;
  final Status status;
  final String cluster;

  Container({
    required this.id,
    required this.name,
    required this.type,
    required this.rating,
    required this.status,
    required this.cluster,
  });

  factory Container.fromMap(Map<String, dynamic> json) {
    return Container(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      rating: json['rating'],
      status: json['status'],
      cluster: json['cluster'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'rating': rating,
      'status': status,
      'cluster': cluster,
    };
  }
}

class DetailedContainer extends Container {
  final int maxKg;
  final int maxVol;
  final double lat;
  final double long;
  final int point;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int clusterId;
  final String userId;

  DetailedContainer({
    required super.id,
    required super.name,
    required super.type,
    required super.rating,
    required super.status,
    required super.cluster,
    required this.maxKg,
    required this.maxVol,
    required this.lat,
    required this.long,
    required this.point,
    required this.createdAt,
    required this.updatedAt,
    required this.clusterId,
    required this.userId,
  });

  factory DetailedContainer.fromMap(Map<String, dynamic> json) {
    return DetailedContainer(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      rating: json['rating'],
      status: json['status'],
      cluster: json['cluster'],
      maxKg: json['max_kg'],
      maxVol: json['max_vol'],
      lat: json['lat'],
      long: json['long'],
      point: json['point'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      clusterId: json['cluster_id'],
      userId: json['user_id'],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map.addAll({
      'max_kg': maxKg,
      'max_vol': maxVol,
      'lat': lat,
      'long': long,
      'point': point,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'cluster_id': clusterId,
      'user_id': userId,
    });
    return map;
  }
}
