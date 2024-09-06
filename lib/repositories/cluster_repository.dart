import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skripsi_mobile/models/cluster.dart';
import 'package:skripsi_mobile/utils/api.dart';

abstract class ClusterRepository {
  Future<List<Cluster>> getClusters();
  Future<Cluster> getClusterById(int id);
}

class ClusterDioRepository implements ClusterRepository {
  final Dio fetcher;

  ClusterDioRepository({required this.fetcher});

  @override
  Future<List<Cluster>> getClusters() async {
    try {
      final response = await fetcher.get('${Api.baseUrl}/cluster');

      // {message: string, data: []}
      final List<Cluster> clusters = (response.data['data'] as List<dynamic>)
          .map((d) => Cluster.fromMap(d as Map<String, dynamic>))
          .toList();

      return clusters;
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
  Future<Cluster> getClusterById(int id) async {
    try {
      final response = await fetcher.get('${Api.baseUrl}/cluster/$id');

      return Cluster.fromMap(response.data['data'][0]);
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

final clusterRepositoryProvider =
    Provider.autoDispose<ClusterRepository>((ref) {
  return ClusterDioRepository(fetcher: ref.watch(dioProvider));
});

final clustersProvider = FutureProvider.autoDispose<List<Cluster>>((ref) {
  return ref.watch(clusterRepositoryProvider).getClusters();
});

final clusterProvider =
    FutureProvider.family.autoDispose<Cluster, int>((ref, id) {
  return ref.watch(clusterRepositoryProvider).getClusterById(id);
});
