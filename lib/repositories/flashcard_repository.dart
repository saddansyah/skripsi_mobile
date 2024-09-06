import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skripsi_mobile/models/flashcard.dart';
import 'package:skripsi_mobile/utils/api.dart';

abstract class FlashcardRepository {
  Future<Flashcard> getRandomFlashcard();
}

class FlashcardDioRepository implements FlashcardRepository {
  final Dio fetcher;

  FlashcardDioRepository(this.fetcher);

  @override
  Future<Flashcard> getRandomFlashcard() async {
    try {
      final response = await fetcher.get('${Api.baseUrl}/flashcard');
      return Flashcard.fromMap(response.data['data'][0]);
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

final flashcardRepositoryProvider =
    Provider.autoDispose<FlashcardRepository>((ref) {
  return FlashcardDioRepository(ref.watch(dioProvider));
});

final flashcardProvider = FutureProvider.autoDispose<Flashcard>((ref) {
  return ref.watch(flashcardRepositoryProvider).getRandomFlashcard();
});
