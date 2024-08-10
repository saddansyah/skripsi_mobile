import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skripsi_mobile/screens/models/collect.dart';
import 'package:skripsi_mobile/utils/interceptor.dart';

abstract class CollectRepository {
  Future<List<Collect>> getMyCollect();
  Future<DetailedCollect> getMyCollectById(int id);
  Future<void> addMyCollect(PayloadCollect collect, File localImageFile);
}

class CollectDioRepository implements CollectRepository {
  final Dio fetcher;

  CollectDioRepository(this.fetcher);

  @override
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

  @override
  Future<DetailedCollect> getMyCollectById(int id) async {
    try {
      final response = await fetcher.get('${Api.baseUrl}/collect/$id');

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

  @override
  Future<void> addMyCollect(PayloadCollect collect, File localImageFile) async {
    try {
      // Handle upload image first
      String fileName = localImageFile.path.split('/').last;
      FormData formData = FormData.fromMap({
        "img": await MultipartFile.fromFile(localImageFile.path,
            filename: fileName)
      });
      final response =
          await fetcher.post('${Api.baseUrl}/image/collect', data: formData);
      final imgPath = 'https://gqukwmsjfyupbgvhdjob.supabase.co/storage/v1/object/authenticated/images/${response.data['data'][0]['path'] as String}';

      // // Assign uploaded image path
      final payload = collect.toMap();
      payload['img'] = imgPath;

      // Upload the payload
      await fetcher.post('${Api.baseUrl}/collect', data: payload);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw 'Koneksi timeout. Terjadi kesalahan di server';
      } else {
        throw e;
      }
    } catch (e) {
      rethrow;
    }
  }
}

final collectRepositoryProvider =
    Provider.autoDispose<CollectRepository>((ref) {
  return CollectDioRepository(ref.watch(dioProvider));
});

final collectsProvider = FutureProvider.autoDispose<List<Collect>>((ref) {
  return ref.watch(collectRepositoryProvider).getMyCollect();
});

final collectProvider =
    FutureProvider.family.autoDispose<DetailedCollect, int>((ref, id) {
  return ref.watch(collectRepositoryProvider).getMyCollectById(id);
});
