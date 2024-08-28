import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skripsi_mobile/controller/auth_controller.dart';
import 'package:skripsi_mobile/controller/quiz_controller.dart';
import 'package:skripsi_mobile/controller/timer_controller.dart';
import 'package:skripsi_mobile/models/quiz.dart';
import 'package:skripsi_mobile/models/ui/input_card.dart';
import 'package:skripsi_mobile/repositories/auth_repository.dart';
import 'package:skripsi_mobile/repositories/quiz_repository.dart';
import 'package:skripsi_mobile/screens/exception/error_screen.dart';
import 'package:skripsi_mobile/shared/bottom_sheet/alert_bottom_sheet.dart';
import 'package:skripsi_mobile/shared/bottom_sheet/confirmation_bottom_sheet.dart';
import 'package:skripsi_mobile/shared/image/image_error.dart';
import 'package:skripsi_mobile/shared/image/image_with_token.dart';
import 'package:skripsi_mobile/shared/input/quiz_select_input.dart';
import 'package:skripsi_mobile/shared/pills/added_point.pill.dart';
import 'package:skripsi_mobile/theme.dart';
import 'package:skripsi_mobile/utils/extension.dart';

class QuizScreen extends ConsumerStatefulWidget {
  const QuizScreen({super.key});

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  bool isStarted = false;
  final initialTime = 30;

  bool isSelected = true;
  String selectedAnswer = '';
  void updateSelected(String answer) {
    setState(() {
      selectedAnswer = answer;
    });
  }

  void handleSubmit(Quiz quiz) {
    final answer = PayloadQuiz(
      quizId: quiz.id,
      answer: selectedAnswer,
      uniqueId: quiz.uniqueId,
    );

    ref.read(quizControllerProvider.notifier).checkQuizAnswer(answer);
  }

  void exitToHome(CountdownTimerController controller) {
    controller.resetTimer();
    Navigator.of(context, rootNavigator: true)
        .popUntil((route) => route.isFirst);
    setState(() {
      isStarted = false;
    });
  }

  void exitToDailyQuiz(CountdownTimerController controller) {
    controller.resetTimer();
    setState(() {
      isStarted = false;
    });
  }

  void handleExit(CountdownTimerController controller) {
    if (isStarted) {
      selectedAnswer = '';
      controller.pauseTimer();
      showModalBottomSheet(
          isDismissible: false,
          enableDrag: false,
          context: context,
          builder: (context) {
            return ConfirmationBottomSheet(
              onDismissPressed: () {
                controller.startTimer();
              },
              onConfirmPressed: () {
                exitToHome(controller);
              },
              title: 'Apakah kamu yakin ingin keluar dari quiz?',
              message:
                  'Sayang sekali, kamu akan kehilangan poinmu dari menjawab benar quiz 😔',
              color: AppColors.red,
              yes: 'Ya, keluar',
              no: 'Tidak jadi deh',
            );
          });
    } else {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final timer = ref.watch(timerControllerProvider(initialTime));
    final timerController =
        ref.read(timerControllerProvider(initialTime).notifier);
    final state = ref.watch(quizControllerProvider);
    final quiz = ref.watch(quizProvider);

    ref.listen(quizControllerProvider, (_, s) {
      if (s.hasError && !s.isLoading) {
        s.showErrorSnackbar(context);
      }

      if (s.isLoading) {
        s.showLoadingSnackbar(context, 'Mengecek jawaban..');
      }

      if (!s.hasError && !s.isLoading) {
        if (s.value!.isCorrect) {
          s.showSnackbar(context, s.value?.message ?? '-');
          exitToHome(timerController);
        } else {
          s.showErrorSnackbar(context, s.value?.message ?? '-');
          exitToDailyQuiz(timerController);
        }
      }
    });

    ref.listen(timerControllerProvider(initialTime), (_, second) {
      if (second <= 0) {
        showModalBottomSheet(
          isDismissible: false,
          enableDrag: false,
          context: context,
          builder: (context) {
            return AlertBottomSheet(
              onConfirmPressed: () {
                timerController.resetTimer();
                Navigator.of(context, rootNavigator: true).pop();
                setState(() {
                  isStarted = false;
                });
              },
              title: 'Ups, Waktu Habis ⌛',
              message:
                  'Sayang sekali, waktumu untuk mengerjakan quiz telah habis. Kamu dapat memulai quiz baru pada halaman Daily Quiz.',
              color: AppColors.red,
              buttonText: 'Baiklah',
            );
          },
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 72,
        title: Text('Daily Quiz', style: Fonts.semibold16),
        leading: IconButton(
            onPressed: () {
              handleExit(timerController);
            },
            icon: Icon(Icons.arrow_back_rounded)),
        actions: [
          Container(
            padding: EdgeInsets.fromLTRB(9, 6, 12, 6),
            decoration: BoxDecoration(
              color: timer > 10
                  ? AppColors.bluePrimary
                  : timer > 0 && timer < 10
                      ? AppColors.amber
                      : AppColors.red,
              borderRadius: BorderRadius.all(
                Radius.circular(24),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.timer_rounded, color: AppColors.white, size: 27),
                SizedBox(width: 12),
                Text(
                  timer > 9 ? '00:$timer' : '00:0$timer',
                  style: Fonts.semibold16
                      .copyWith(color: AppColors.white, fontSize: 21),
                ),
              ],
            ),
          ),
          SizedBox(width: 24)
        ],
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: !isStarted
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(24)),
                      color: AppColors.amber,
                    ),
                  ),
                  SizedBox(height: 36),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Selamat Datang di Daily Quiz', style: Fonts.bold18),
                      SizedBox(height: 12),
                      Text(
                        'Kamu akan diberikan pertanyaan dan diharuskan untuk menjawab jawaban yang benar untuk mendapatkan poin',
                        style: Fonts.regular14,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  SizedBox(height: 36),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: AppColors.bluePrimary,
                        foregroundColor: AppColors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        )),
                    onPressed: () {
                      timerController.startTimer();
                      setState(() {
                        isStarted = true;
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 60,
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Mulai Kuis',
                            style: Fonts.bold16,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : quiz.when(
                error: (e, _) => ErrorScreen(
                  buttonText: 'Muat Ulang',
                  message: e.toString(),
                  isRefreshing: quiz.isRefreshing,
                  onPressed: () {
                    ref.invalidate(quizProvider);
                  },
                ),
                loading: () => Center(
                  child:
                      CircularProgressIndicator(color: AppColors.greenPrimary),
                ),
                data: (q) {
                  List<Input<String>> options = q.options.split(';').map((_q) {
                    return Input(_q, _q);
                  }).toList();

                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(24),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(18),
                            ),
                            color: AppColors.bluePrimary,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Kuis #Q${q.id}',
                                    style: Fonts.bold18
                                        .copyWith(color: AppColors.white),
                                  ),
                                  SizedBox(width: 12),
                                  AddedPointPill(point: 3),
                                ],
                              ),
                              SizedBox(height: 12),
                              Container(
                                width: double.infinity,
                                height: 180,
                                decoration: BoxDecoration(
                                  color:
                                      AppColors.blueSecondary.withOpacity(0.3),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
                                ),
                                clipBehavior: Clip.hardEdge,
                                child: ImageWithToken(q.img),
                              ),
                              SizedBox(height: 12),
                              Text(
                                q.question,
                                style: Fonts.semibold14
                                    .copyWith(color: AppColors.white),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 12),
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(24),
                            ),
                            border:
                                Border.all(width: 2, color: Colors.grey[350]!),
                          ),
                          child: Column(
                            children: [
                              ListView.builder(
                                itemCount: options.length,
                                shrinkWrap: true,
                                itemBuilder: (context, i) {
                                  return QuizSelectInput(
                                      isSelected:
                                          selectedAnswer == options[i].value,
                                      index: i,
                                      input: options[i],
                                      updateSelected: updateSelected);
                                },
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 12),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: state.isLoading
                                  ? AppColors.grey
                                  : AppColors.greenPrimary,
                              foregroundColor: AppColors.white,
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                              )),
                          onPressed: state.isLoading
                              ? null
                              : () {
                                  handleSubmit(q);
                                },
                          child: Container(
                            padding: EdgeInsets.all(24),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: state.isLoading
                                  ? [
                                      CircularProgressIndicator(
                                          color: AppColors.white)
                                    ]
                                  : [
                                      Text(
                                        'Kumpul Jawaban',
                                        style: Fonts.bold16,
                                      ),
                                    ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
