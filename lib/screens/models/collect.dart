import 'package:skripsi_mobile/utils/constants/enums.dart';

class Collect {
  final int id;
  final WasteType type;
  final Status status;
  final String img;
  final int point;
  final DateTime createdAt;
  final int containerId;
  final String containerName;

  Collect(
      {required this.id,
      required this.type,
      required this.status,
      required this.img,
      required this.point,
      required this.createdAt,
      required this.containerId,
      required this.containerName});

  factory Collect.fromMap(Map<String, dynamic> json) {
    return Collect(
        id: json['id'],
        type: WasteType.values.firstWhere((v) => v.value == json['type']),
        status: Status.values.firstWhere((v) => v.value == json['status']),
        img: json['img'],
        point: json['point'],
        createdAt: DateTime.parse(json['created_at']),
        containerId: json['container_id'],
        containerName: json['container_name']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'status': status,
      'img': img,
      'point': point,
      'created_at': createdAt.toIso8601String(),
      'container_id': containerId,
      'container_name': containerName
    };
  }
}

class DetailedCollect extends Collect {
  final num kg;
  final num vol;
  final String info;
  final bool isAnonim;
  final DateTime updatedAt;

  DetailedCollect({
    required super.id,
    required super.type,
    required super.status,
    required super.img,
    required super.point,
    required super.createdAt,
    required super.containerId,
    required super.containerName,
    required this.kg,
    required this.vol,
    required this.info,
    required this.isAnonim,
    required this.updatedAt,
  });

  factory DetailedCollect.fromMap(Map<String, dynamic> json) {
    return DetailedCollect(
      id: json['id'],
      type: WasteType.values.firstWhere((v) => v.value == json['type']),
      status: Status.values.firstWhere((v) => v.value == json['status']),
      img: json['img'],
      point: json['point'],
      createdAt: DateTime.parse(json['created_at']),
      containerId: json['container_id'],
      containerName: json['container_name'],
      kg: json['kg'],
      vol: json['vol'],
      info: json['info'],
      isAnonim: json['is_anonim'],
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map.addAll({
      'kg': kg,
      'vol': vol,
      'info': info,
      'is_anonim': isAnonim,
      'updated_at': updatedAt.toIso8601String(),
    });
    return map;
  }
}
