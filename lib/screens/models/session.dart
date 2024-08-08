import 'package:skripsi_mobile/screens/models/user.dart';

class Session {
  Session({required this.accessToken, required this.refreshToken});

  final String accessToken;
  final String refreshToken;

  factory Session.fromMap(Map<String, dynamic> json) {
    final data = json['data'][0];

    return Session(
      accessToken: data['access_token'],
      refreshToken: data['refresh_token'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
    };
  }
}
