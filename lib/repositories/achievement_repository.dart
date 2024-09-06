import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skripsi_mobile/models/achievement.dart';
import 'package:skripsi_mobile/models/user.dart';
import 'package:skripsi_mobile/utils/api.dart';

abstract class AchievementRepository {
  Future<List<Achievement>> getMyAchievements();
}

abstract class LeaderboardRepository {
  Future<List<LeaderboardUser>> getLeaderboard();
}

class AchievementDioRepository implements AchievementRepository {
  final Dio fetcher;

  AchievementDioRepository(this.fetcher);

  @override
  Future<List<Achievement>> getMyAchievements() async {
    try {
      final response = await fetcher.get('${Api.baseUrl}/my/achievement');

      // {message: string, data: []}
      final List<Achievement> achievements =
          (response.data['data'] as List<dynamic>)
              .map((d) => Achievement.fromMap(d as Map<String, dynamic>))
              .toList();

      return achievements;
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

class LeaderboardDioRepository implements LeaderboardRepository {
  final Dio fetcher;

  LeaderboardDioRepository(this.fetcher);

  @override
  Future<List<LeaderboardUser>> getLeaderboard() async {
    try {
      final response = await fetcher.get('${Api.baseUrl}/my/leaderboard');

      // {message: string, data: []}
      final List<LeaderboardUser> leaderboardUsers =
          (response.data['data'] as List<dynamic>)
              .map((d) => LeaderboardUser.fromMap(d as Map<String, dynamic>))
              .toList();

      return leaderboardUsers;
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

final achievementRepositoryProvider = Provider<AchievementRepository>((ref) {
  return AchievementDioRepository(ref.watch(dioProvider));
});

final leaderboardRepositoryProvider = Provider<LeaderboardRepository>((ref) {
  return LeaderboardDioRepository(ref.watch(dioProvider));
});

final myAchievementsProvider =
    FutureProvider.autoDispose<List<Achievement>>((ref) {
  return ref.watch(achievementRepositoryProvider).getMyAchievements();
});

final leaderboardUsersProvider =
    FutureProvider.autoDispose<List<LeaderboardUser>>((ref) {
  return ref.watch(leaderboardRepositoryProvider).getLeaderboard();
});
