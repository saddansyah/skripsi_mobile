import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skripsi_mobile/models/quiz.dart';
import 'package:skripsi_mobile/utils/api.dart';

abstract class QuizRepository {
  Future<Quiz> getRandomQuiz();
  Future<ResponseQuiz> checkQuizAnswer(PayloadQuiz answer);
  Future<QuizStatus> checkQuizStatus();
}

class QuizDioRepository implements QuizRepository {
  final Dio fetcher;

  QuizDioRepository(this.fetcher);

  @override
  Future<ResponseQuiz> checkQuizAnswer(PayloadQuiz answer) async {
    try {
      final payload = answer.toMap();
      final response = await fetcher.post('${Api.baseUrl}/quiz', data: payload);

      final data = response.data['data'] as List<dynamic>;

      if (data.isEmpty) {
        return ResponseQuiz(
            isCorrect: false,
            message: 'Sayang sekali, jawaban kamu belum benar..');
      } else {
        return ResponseQuiz(
            isCorrect: true, message: 'Selamat! Jawaban kamu benar!');
      }
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
  Future<Quiz> getRandomQuiz() async {
    try {
      final response = await fetcher.get('${Api.baseUrl}/quiz');
      return Quiz.fromMap(response.data['data'][0]);
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
  Future<QuizStatus> checkQuizStatus() async {
    try {
      final response = await fetcher.get('${Api.baseUrl}/quiz/status');

      return QuizStatus.fromMap(response.data['data']?[0]);
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

final quizRepositoryProvider = Provider.autoDispose<QuizRepository>((ref) {
  return QuizDioRepository(ref.watch(dioProvider));
});

final quizProvider = FutureProvider.autoDispose<Quiz>((ref) {
  return ref.watch(quizRepositoryProvider).getRandomQuiz();
});

final quizStatusProvider = FutureProvider.autoDispose<QuizStatus>((ref) {
  return ref.watch(quizRepositoryProvider).checkQuizStatus();
});
