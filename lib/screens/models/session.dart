import 'package:skripsi_mobile/screens/models/user.dart';

class Session {
  Session({required this.accessToken, required this.refreshToken});

  final String accessToken;
  final String refreshToken;

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
    };
  }
}
