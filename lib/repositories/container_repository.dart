import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skripsi_mobile/models/container.dart';
import 'package:skripsi_mobile/utils/api.dart';

abstract class ContainerRepository {
  Future<List<Container>> getContainer(String query);
  Future<DetailedContainer> getContainerById(int id);
  Future<void> addContainer(PayloadContainer container);
  Future<void> updateContainer(PayloadContainer container, int id);
  Future<void> deleteContainer(int id);
}

class ContainerDioRepository implements ContainerRepository {
  final Dio fetcher;

  ContainerDioRepository({required this.fetcher});

  @override
  Future<List<Container>> getContainer(String query) async {
    try {
      final response = await fetcher.get('${Api.baseUrl}/container/$query');

      // {message: string, data: []}
      final List<Container> containers =
          (response.data['data'] as List<dynamic>)
              .map((d) => Container.fromMap(d as Map<String, dynamic>))
              .toList();

      return containers;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw 'Koneksi timeout. Terjadi kesalahan di server';
      } else {
        print(e);
        throw throw 'Terjadi galat pada server (${e.response?.statusCode})';
      }
    }
  }

  @override
  Future<DetailedContainer> getContainerById(int id) async {
    try {
      final response = await fetcher.get('${Api.baseUrl}/container/$id');

      return DetailedContainer.fromMap(response.data['data'][0]);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw 'Koneksi timeout. Terjadi kesalahan di server';
      } else {
        print(e);
        throw throw 'Terjadi galat pada server (${e.response?.statusCode})';
      }
    }
  }

  @override
  Future<void> addContainer(PayloadContainer container) async {
    try {
      final payload = container.toMap();
      await fetcher.post('${Api.baseUrl}/container', data: payload);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw 'Koneksi timeout. Terjadi kesalahan di server';
      } else {
        throw 'Terjadi galat saat melakukan tambah data. Coba lagi.';
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteContainer(int id) async {
    try {
      await fetcher.delete('${Api.baseUrl}/container/$id');
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw 'Koneksi timeout. Terjadi kesalahan di server';
      } else {
        throw 'Terjadi galat saat melakukan tambah data. Coba lagi.';
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateContainer(PayloadContainer container, int id) {
    // TODO: implement updateContainer
    throw UnimplementedError();
  }
}

final containerRepositoryProvider =
    Provider.autoDispose<ContainerRepository>((ref) {
  return ContainerDioRepository(fetcher: ref.watch(dioProvider));
});

final containersProvider =
    FutureProvider.family.autoDispose<List<Container>, String>((ref, query) {
  return ref.watch(containerRepositoryProvider).getContainer(query);
});

final containerProvider =
    FutureProvider.family.autoDispose<DetailedContainer, int>((ref, id) {
  return ref.watch(containerRepositoryProvider).getContainerById(id);
});
