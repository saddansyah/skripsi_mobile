import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skripsi_mobile/models/evidence_rating.dart';
import 'package:skripsi_mobile/repositories/container_repository.dart';
import 'package:skripsi_mobile/utils/api.dart';

abstract class EvidenceRatingRepository {
  Future<EvidenceRating?> getMyEvidenceRatingByContainerId(int containerId);
  Future<void> addContainerRating(PayloadEvidenceRating rating);
  Future<void> deleteContainerRating(int containerId);
}

class EvidenceRatingRepositoryImpl implements EvidenceRatingRepository {
  final Dio fetcher;

  EvidenceRatingRepositoryImpl({required this.fetcher});

  @override
  Future<void> addContainerRating(PayloadEvidenceRating rating) async {
    try {
      final payload = rating.toMap();
      await fetcher.post('${Api.baseUrl}/rating/container', data: payload);
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
  Future<void> deleteContainerRating(int containerId) async {
    try {
      await fetcher.delete('${Api.baseUrl}/rating/container/$containerId');
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
  Future<EvidenceRating?> getMyEvidenceRatingByContainerId(
      int containerId) async {
    try {
      final response =
          await fetcher.get('${Api.baseUrl}/rating/container/$containerId');

      return (response.data['data'] as List<dynamic>).isNotEmpty
          ? EvidenceRating.fromMap(response.data['data'][0])
          : null;
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

final evidenceRatingRepositoryProvider =
    Provider.autoDispose<EvidenceRatingRepository>((ref) {
  return EvidenceRatingRepositoryImpl(fetcher: ref.watch(dioProvider));
});

final evidenceRatingProvider =
    FutureProvider.family.autoDispose<EvidenceRating?, int>((ref, containerId) {
  return ref
      .watch(evidenceRatingRepositoryProvider)
      .getMyEvidenceRatingByContainerId(containerId);
});
