import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skripsi_mobile/models/daily_sign_in.dart';
import 'package:skripsi_mobile/utils/api.dart';

abstract class DailySignInRepository {
  Future<DailySignInStatus> checkDailySignInStatus();
  Future<DailySignInStreak> checkDailySignInStreak();
  Future<void> claimDailySignInStatus();
  Future<void> claimDailySignInStreak();
}

class DailySignInDioRepository implements DailySignInRepository {
  final Dio fetcher;

  DailySignInDioRepository(this.fetcher);

  @override
  Future<DailySignInStatus> checkDailySignInStatus() async {
    try {
      final response = await fetcher.get('${Api.baseUrl}/daily-sign-in');

      return DailySignInStatus.fromMap(response.data['data'][0]);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw 'Koneksi timeout. Terjadi kesalahan di server';
      } else {
        print(e);
        throw 'Terjadi galat pada server (${e.response?.statusCode})';
      }
    }
  }

  @override
  Future<DailySignInStreak> checkDailySignInStreak() async {
    try {
      final response = await fetcher.get('${Api.baseUrl}/daily-sign-in/streak');

      return DailySignInStreak.fromMap(response.data['data']?[0]);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw 'Koneksi timeout. Terjadi kesalahan di server';
      } else {
        print(e);
        throw 'Terjadi galat pada server (${e.response?.statusCode})';
      }
    }
  }

  @override
  Future<void> claimDailySignInStatus() async {
    try {
      await fetcher.post('${Api.baseUrl}/daily-sign-in');
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw 'Koneksi timeout. Terjadi kesalahan di server';
      } else {
        print(e);
        throw 'Terjadi galat pada server (${e.response?.statusCode})';
      }
    }
  }

  @override
  Future<void> claimDailySignInStreak() async {
    try {
      await fetcher.post('${Api.baseUrl}/daily-sign-in/streak');
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw 'Koneksi timeout. Terjadi kesalahan di server';
      } else {
        print(e);
        throw 'Terjadi galat pada server (${e.response?.statusCode})';
      }
    }
  }
}

final dailySignInRepositoryProvider =
    Provider.autoDispose<DailySignInRepository>((ref) {
  return DailySignInDioRepository(ref.watch(dioProvider));
});

final dailySignInStatusProvider =
    FutureProvider.autoDispose<DailySignInStatus>((ref) {
  return ref.watch(dailySignInRepositoryProvider).checkDailySignInStatus();
});

final dailySignInStreakProvider =
    FutureProvider.autoDispose<DailySignInStreak>((ref) {
  return ref.watch(dailySignInRepositoryProvider).checkDailySignInStreak();
});
