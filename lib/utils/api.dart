import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skripsi_mobile/controller/auth_controller.dart';
import 'package:skripsi_mobile/models/session.dart';

class Api {
  // static String baseUrl = 'http://10.0.2.2:8000/api';
  static String baseUrl = 'https://skripsi-be-local.saddansyah.my.id/api';
  static String supabaseUrl = 'https://lkrrautkotvuligmtgih.supabase.co';

  static BaseOptions dioOptions = BaseOptions(
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  );
}

class TokenInterceptor extends Interceptor {
  final Session? s;
  final Ref ref;

  TokenInterceptor({required this.s, required this.ref});

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    if (s?.accessToken != null) {
      options.headers['Authorization'] = 'Bearer ${s?.accessToken}';
    }

    return super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      try {
        await ref
            .read(authControllerProvider.notifier)
            .refreshToken(s!.refreshToken);
        final authState = ref.read(authControllerProvider);
        final newSession = authState.value;

        if (newSession != null) {
          err.requestOptions.headers['Authorization'] =
              'Bearer ${newSession.accessToken}';
          final response = await Dio().fetch(err.requestOptions);
          return handler.resolve(response);
        }
      } catch (e) {
        return handler.reject(err);
      }
    }
    return super.onError(err, handler);
  }
}

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(Api.dioOptions);
  dio.interceptors.add(TokenInterceptor(
    s: ref.watch(authControllerProvider).value,
    ref: ref,
  ));
  return dio;
});
