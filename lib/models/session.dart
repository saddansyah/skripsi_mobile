import 'package:skripsi_mobile/models/user.dart';

class Session {
  Session({required this.accessToken, required this.refreshToken});

  final String accessToken;
  final String refreshToken;

  factory Session.fromMap(Map<String, dynamic> json) {
    return Session(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
    );
  }
}
