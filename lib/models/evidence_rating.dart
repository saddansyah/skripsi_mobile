class EvidenceRating {
  final int value;
  final bool isAnonim;
  final String info;
  final int point;
  final DateTime createdAt;
  final int containerId;
  final String userId;

  EvidenceRating(
      {required this.value,
      required this.isAnonim,
      required this.info,
      required this.point,
      required this.createdAt,
      required this.containerId,
      required this.userId});

  factory EvidenceRating.fromMap(Map<String, dynamic> json) {
    return EvidenceRating(
      value: json['value'],
      isAnonim: json['is_anonim'],
      info: json['info'],
      point: json['point'],
      createdAt: DateTime.parse(json['created_at']),
      containerId: json['container_id'],
      userId: json['user_id'],
    );
  }
}

class PayloadEvidenceRating {
  final int value;
  final bool isAnonim;
  final String info;
  final int containerId;

  PayloadEvidenceRating({
    required this.value,
    required this.isAnonim,
    required this.info,
    required this.containerId,
  });

  Map<String, dynamic> toMap() {
    return {
      'value': value,
      'is_anonim': isAnonim,
      'info': info,
      'container_id': containerId,
    };
  }
}
