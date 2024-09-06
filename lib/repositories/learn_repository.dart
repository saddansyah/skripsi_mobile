import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skripsi_mobile/models/learn.dart';
import 'package:skripsi_mobile/utils/api.dart';

abstract class LearnRepository {
  Future<List<Learn>> getLearns(String query);
  Future<Learn> getLearnById(int id);
}

class LearnDioRepository implements LearnRepository {
  final Dio fetcher;

  LearnDioRepository(this.fetcher);

  @override
  Future<List<Learn>> getLearns(String query) async {
    try {
      final response = await fetcher.get('${Api.baseUrl}/learn/$query');

      // {message: string, data: []}
      final List<Learn> achievements = (response.data['data'] as List<dynamic>)
          .map((d) => Learn.fromMap(d as Map<String, dynamic>))
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

  @override
  Future<Learn> getLearnById(int id) async {
    try {
      final response = await fetcher.get('${Api.baseUrl}/learn/$id');

      return Learn.fromMap(response.data['data'][0]);
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

final learnRepositoryProvider = Provider.autoDispose<LearnRepository>((ref) {
  return LearnDioRepository(ref.watch(dioProvider));
});

final learnsProvider =
    FutureProvider.family.autoDispose<List<Learn>, String>((ref, query) {
  return ref.watch(learnRepositoryProvider).getLearns(query);
});

final learnProvider = FutureProvider.family.autoDispose<Learn, int>((ref, id) {
  return ref.watch(learnRepositoryProvider).getLearnById(id);
});
