import 'package:skripsi_mobile/utils/constants/enums.dart';

class Container {
  final int id;
  final String name;
  final ContainerType type;
  final num rating;
  final int ratingCount;
  final num lat;
  final num long;
  final Status status;
  final int clusterId;
  final String clusterName;
  final String userId;

  Container({
    required this.id,
    required this.name,
    required this.type,
    required this.rating,
    required this.ratingCount,
    required this.status,
    required this.lat,
    required this.long,
    required this.clusterId,
    required this.clusterName,
    required this.userId,
  });

  factory Container.fromMap(Map<String, dynamic> json) {
    return Container(
      id: json['id'],
      name: json['name'],
      type: ContainerType.values.firstWhere((v) => v.value == json['type']),
      rating: json['rating'],
      ratingCount: json['rating_count'],
      lat: json['lat'],
      long: json['long'],
      status: Status.values.firstWhere((v) => v.value == json['status']),
      clusterId: json['cluster_id'],
      clusterName: json['cluster_name'],
      userId: json['user_id'],
    );
  }
}

class DetailedContainer extends Container {
  final num maxKg;
  final num maxVol;
  final int point;
  final DateTime createdAt;
  final DateTime updatedAt;

  DetailedContainer({
    required super.id,
    required super.name,
    required super.type,
    required super.rating,
    required super.ratingCount,
    required super.status,
    required super.clusterId,
    required super.clusterName,
    required super.lat,
    required super.long,
    required this.maxKg,
    required this.maxVol,
    required this.point,
    required this.createdAt,
    required this.updatedAt,
    required super.userId,
  });

  factory DetailedContainer.fromMap(Map<String, dynamic> json) {
    return DetailedContainer(
      id: json['id'],
      name: json['name'],
      type: ContainerType.values.firstWhere((v) => v.value == json['type']),
      status: Status.values.firstWhere((v) => v.value == json['status']),
      rating: json['rating'],
      ratingCount: json['rating_count'],
      maxKg: json['max_kg'],
      maxVol: json['max_vol'],
      lat: json['lat'],
      long: json['long'],
      point: json['point'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      clusterId: json['cluster_id'],
      clusterName: json['cluster_name'],
      userId: json['user_id'],
    );
  }
}

class PayloadContainer {
  PayloadContainer(
      {required this.name,
      required this.maxKg,
      required this.maxVol,
      required this.lat,
      required this.long,
      required this.type,
      required this.clusterId});

  final String name;
  final double maxKg;
  final double maxVol;
  final double lat;
  final double long;
  final ContainerType type;
  final int clusterId;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'max_kg': maxKg,
      'max_vol': maxVol,
      'lat': lat,
      'long': long,
      'type': type.value,
      'cluster_id': clusterId
    };
  }
}

class NearestContainer {
  final int id;
  final String name;
  final num distance;
  final num rating;
  final int ratingCount;
  final num lat;
  final num long;

  NearestContainer({
    required this.id,
    required this.name,
    required this.distance,
    required this.rating,
    required this.ratingCount,
    required this.lat,
    required this.long,
  });

  factory NearestContainer.fromMap(Map<String, dynamic> json) {
    return NearestContainer(
      id: json['id'],
      name: json['name'],
      distance: json['distance'],
      rating: json['rating'],
      ratingCount: json['rating_count'],
      lat: json['lat'],
      long: json['long'],
    );
  }
}
