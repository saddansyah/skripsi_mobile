import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skripsi_mobile/repositories/auth_repository.dart';
import 'package:skripsi_mobile/screens/models/session.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide Session, User;

class Api {
  static String baseUrl = 'http://10.0.2.2:8000/api';
}

BaseOptions options = BaseOptions(
  connectTimeout: const Duration(seconds: 8),
  receiveTimeout: const Duration(seconds: 5),
);

class TokenInterceptor extends Interceptor {
  final Session? s;

  TokenInterceptor({required this.s});

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    if (s?.accessToken != null) {
      options.headers['Authorization'] = 'Bearer ${s?.accessToken}';
    }

    return super.onRequest(options, handler);
  }

  @override
  void onError(err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // Token expired, refresh token
      try {
        final refreshed =
            await Supabase.instance.client.auth.refreshSession(s?.refreshToken);

        err.requestOptions.headers['Authorization'] =
            'Bearer ${refreshed.session?.accessToken}';

        final response = await Dio().fetch(err.requestOptions);
        return handler.resolve(response);
      } catch (e) {
        return handler.reject(err);
      }
    }

    return super.onError(err, handler);
  }
}

final dioProvider = Provider.autoDispose<Dio>((ref) {
  final dio = Dio(options);
  dio.interceptors.add(TokenInterceptor(s: ref.watch(sessionProvider).value));
  return dio;
});
