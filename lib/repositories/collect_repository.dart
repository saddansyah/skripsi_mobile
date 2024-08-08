import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skripsi_mobile/screens/models/collect.dart';
import 'package:skripsi_mobile/utils/interceptor.dart';

class CollectRepository {
  final Dio fetcher;

  CollectRepository(this.fetcher);

  Future<List<Collect>> getMyCollect() async {
    try {
      final response = await fetcher.get('${Api.baseUrl}/collect');

      // {message: string, data: []}
      final List<Collect> collects = (response.data['data'] as List<dynamic>)
          .map((d) => Collect.fromMap(d as Map<String, dynamic>))
          .toList();

      return collects;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw 'Koneksi timeout. Terjadi kesalahan di server';
      } else {
        throw 'Terjadi galat pada server';
      }
    }
  }

  Future<DetailedCollect> getMyCollectById(int id) async {
    try {
      final response = await fetcher.get('${Api.baseUrl}/collect/$id');

      print(response.data['data'][0]);

      return DetailedCollect.fromMap(response.data['data'][0]);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw 'Koneksi timeout. Terjadi kesalahan di server';
      } else {
        throw 'Terjadi galat pada server';
      }
    }
  }
}

final collectRepositoryProvider =
    Provider.autoDispose<CollectRepository>((ref) {
  return CollectRepository(ref.watch(dioProvider));
});

final collectsProvider = FutureProvider.autoDispose<List<Collect>>((ref) {
  return ref.watch(collectRepositoryProvider).getMyCollect();
});

final collectProvider =
    FutureProvider.family.autoDispose<DetailedCollect, int>((ref, id) {
  return ref.watch(collectRepositoryProvider).getMyCollectById(id);
});
