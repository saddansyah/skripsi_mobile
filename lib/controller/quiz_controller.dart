import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skripsi_mobile/models/quiz.dart';
import 'package:skripsi_mobile/repositories/quiz_repository.dart';

class QuizController extends AsyncNotifier<ResponseQuiz> {
  @override
  ResponseQuiz build() {
    return ResponseQuiz(isCorrect: false, message: '');
  }

  Future<void> checkQuizAnswer(PayloadQuiz answer) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
        () => ref.read(quizRepositoryProvider).checkQuizAnswer(answer));
  }
}

final quizControllerProvider =
    AsyncNotifierProvider<QuizController, ResponseQuiz>(QuizController.new);
