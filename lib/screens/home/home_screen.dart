import 'dart:async';
import 'package:skripsi_mobile/repositories/collect_repository.dart';
import 'package:skripsi_mobile/shared/appbar/styled_appbar.dart';
import 'package:skripsi_mobile/shared/dialog/flashcard_dialog.dart';
import 'package:skripsi_mobile/utils/string.dart';
import 'package:vector_math/vector_math.dart' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:skripsi_mobile/repositories/profile_repository.dart';
import 'package:skripsi_mobile/repositories/quiz_repository.dart';
import 'package:skripsi_mobile/screens/home/quiz/quiz_screen.dart';
import 'package:skripsi_mobile/screens/layout/main_layout.dart';
import 'package:skripsi_mobile/shared/pills/added_point.pill.dart';
import 'package:skripsi_mobile/theme.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String formatCountdown(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return '$hours:$minutes:$seconds';
  }

  // Quiz
  Timer? quizTimer;
  Duration quizCountdownDuration = const Duration();
  void startQuizCountdown(bool isQuizReady, DateTime nextDate) {
    if (quizTimer != null) return;

    if (isQuizReady) {
      quizTimer?.cancel();
      quizTimer = null;
      return;
    }

    if (!isQuizReady) {
      quizTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        setState(() {
          quizCountdownDuration =
              nextDate.toLocal().difference(DateTime.now().toLocal());

          if (quizCountdownDuration.isNegative) {
            quizTimer?.cancel();
            quizTimer = null;
            quizCountdownDuration = const Duration();
            return;
          }
        });
      });
    }
  }

  // Flashcard
  Timer? flashcardTimer;
  Duration flashcardCountdownDuration = const Duration();
  bool isFlashcardReady = true;
  void showFlashcard() {
    showGeneralDialog(
      context: context,
      pageBuilder: (ctx, a1, a2) {
        return Container();
      },
      transitionBuilder: (ctx, a1, a2, child) {
        final curvedAnimation =
            CurvedAnimation(parent: a1, curve: Curves.easeOutBack);
        return FadeTransition(
          opacity: curvedAnimation,
          child: Transform.rotate(
            angle: math.radians(60 * (1 - curvedAnimation.value)),
            child: const FlashcardDialog(),
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  void startFlashcardCountdown(DateTime nextTime) {
    if (flashcardTimer != null) return;
    flashcardTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        final now = DateTime.now().toLocal();
        flashcardCountdownDuration = nextTime.toLocal().difference(now);
        isFlashcardReady = now.isAfter(nextTime);

        if (flashcardCountdownDuration.isNegative) {
          flashcardTimer?.cancel();
          flashcardTimer = null;
          flashcardCountdownDuration = const Duration();
          return;
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    flashcardTimer?.cancel();
    flashcardTimer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final my = ref.watch(profileProvider);
    final quizStatus = ref.watch(quizStatusProvider);
    final summary = ref.watch(collectSummaryProvider);

    return Scaffold(
      appBar: StyledAppBar.main(title: '♻️ Skripsi-Mobile'),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.refresh(quizStatusProvider.future);
          await ref.refresh(profileProvider.future);
          await ref.refresh(collectSummaryProvider.future);
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Greeting
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        AppColors.white,
                        Colors.green[100]!,
                      ]),
                      borderRadius: const BorderRadius.all(Radius.circular(24)),
                      border: Border.all(width: 1, color: Colors.green[200]!)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Halo, ${my.value?.name.split(' ')[0] ?? 'User'} 👋',
                        style: Fonts.bold18.copyWith(
                            color: AppColors.greenPrimary, fontSize: 24),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Buat pengalaman mengelola sampahmu menjadi menyenangkan!',
                        style: Fonts.regular14.copyWith(color: AppColors.dark2),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                // Card 1
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(24)),
                      color: AppColors.red),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Masih Bingung?',
                          style: Fonts.semibold16
                              .copyWith(color: AppColors.white)),
                      TextButton(
                        style: TextButton.styleFrom(
                            elevation: 0,
                            backgroundColor: AppColors.dark2.withOpacity(0.3),
                            foregroundColor: AppColors.white,
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(72)),
                            )),
                        onPressed: () {
                          ref.read(navigationPageProvider).animateTo(1);
                        },
                        child: Text(
                          'Mulai Milestone!',
                          style:
                              Fonts.semibold14.copyWith(color: AppColors.white),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  height: 200,
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 2, color: AppColors.greenSecondary),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(24)),
                              gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    AppColors.greenSecondary,
                                    Colors.lightGreen[200]!
                                  ])),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Jumlah Kumpul Sampah hari ini',
                                style: Fonts.semibold14
                                    .copyWith(color: Colors.green[900]),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 9),
                              Text(
                                '${summary.value?.dailyCollectCount ?? '...'}',
                                style: Fonts.bold18.copyWith(
                                    fontSize: 60, color: Colors.green[700]),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 2, color: AppColors.blueSecondary),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(24)),
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  AppColors.blueSecondary,
                                  Colors.lightBlue[200]!
                                ]),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Jenis Sampah Terbanyak',
                                style: Fonts.semibold14
                                    .copyWith(color: Colors.lightBlue[900]),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 12),
                              SvgPicture.asset('assets/svgs/container_icon.svg',
                                  height: 60),
                              const SizedBox(height: 6),
                              Text(
                                summary.value?.mostCollectType == null
                                    ? 'Tidak Ada'
                                    : summary.value?.mostCollectType?.value
                                            .split('_')
                                            .map((l) => l.capitalize())
                                            .join(' ') ??
                                        '...',
                                style: Fonts.regular14
                                    .copyWith(color: Colors.lightBlue[900]),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(24)),
                      color: AppColors.greenPrimary),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Kumpulkan ⭐${my.value?.nextPoint ?? '-'} lagi untuk menjadi ${my.value?.nextRank ?? '-'}!',
                          style:
                              Fonts.semibold14.copyWith(color: AppColors.white),
                        ),
                      ),
                      const SizedBox(width: 12),
                      TextButton(
                        style: TextButton.styleFrom(
                            elevation: 0,
                            backgroundColor: AppColors.dark2.withOpacity(0.3),
                            foregroundColor: AppColors.white,
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(72)),
                            )),
                        onPressed: () {
                          ref.read(navigationPageProvider).animateTo(2);
                        },
                        child: Text(
                          'Mulai Misi!',
                          style:
                              Fonts.semibold14.copyWith(color: AppColors.white),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(24),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border:
                        Border.all(width: 2, color: AppColors.blueSecondary),
                    borderRadius: const BorderRadius.all(Radius.circular(24)),
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.blueSecondary,
                          Colors.lightBlue[200]!
                        ]),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Mainkan Daily Quiz',
                              style: Fonts.semibold16
                                  .copyWith(color: Colors.lightBlue[900]),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.fromLTRB(6, 3, 9, 3),
                            decoration: BoxDecoration(
                              color: AppColors.bluePrimary,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(24),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.timer_rounded,
                                    color: AppColors.white),
                                const SizedBox(width: 6),
                                Text(
                                  '30s',
                                  style: Fonts.semibold14
                                      .copyWith(color: AppColors.white),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Quiz Button
                      quizStatus.when(
                        loading: () => Center(
                          child: CircularProgressIndicator(
                              color: AppColors.bluePrimary),
                        ),
                        error: (e, s) => Container(
                          alignment: Alignment.center,
                          height: 60,
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(24)),
                              color: AppColors.bluePrimary.withOpacity(0.2)),
                          width: double.infinity,
                          child: GestureDetector(
                            onTap: () {
                              ref.invalidate(quizStatusProvider);
                            },
                            child: Text(
                                quizStatus.isRefreshing
                                    ? '...'
                                    : 'Galat saat memuat kuis 😔',
                                style: Fonts.semibold14
                                    .copyWith(color: AppColors.bluePrimary)),
                          ),
                        ),
                        data: (d) {
                          final isQuizReady = DateTime.now()
                              .toLocal()
                              .isAfter(d.nextDate.toLocal());

                          // startQuizCountdown based on boolean values
                          startQuizCountdown(isQuizReady, d.nextDate);

                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                disabledBackgroundColor:
                                    AppColors.bluePrimary.withOpacity(0.2),
                                disabledForegroundColor: AppColors.bluePrimary,
                                elevation: 0,
                                backgroundColor: AppColors.bluePrimary,
                                foregroundColor: AppColors.white,
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
                                )),
                            onPressed: !isQuizReady
                                ? null
                                : () {
                                    Navigator.of(context, rootNavigator: true)
                                        .push(
                                      MaterialPageRoute(
                                        builder: (_) => const QuizScreen(),
                                      ),
                                    );
                                  },
                            child: Container(
                              height: 60,
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: !isQuizReady
                                    ? [
                                        Text(
                                          'Mulai (${formatCountdown(quizCountdownDuration)})',
                                          style: Fonts.bold16,
                                        )
                                      ]
                                    : [
                                        Text(
                                          'Mulai',
                                          style: Fonts.bold16,
                                        ),
                                        const SizedBox(width: 12),
                                        const AddedPointPill(point: 3)
                                      ],
                              ),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(24)),
                      color: AppColors.blueSecondary),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text('Tambah ilmu dengan #LebihTahu!',
                            style: Fonts.semibold16
                                .copyWith(color: Colors.lightBlue[900])),
                      ),
                      const SizedBox(width: 12),
                      TextButton(
                        style: TextButton.styleFrom(
                            foregroundColor: AppColors.white,
                            disabledBackgroundColor:
                                AppColors.bluePrimary.withOpacity(0.2),
                            disabledForegroundColor: AppColors.bluePrimary,
                            elevation: 0,
                            backgroundColor: AppColors.bluePrimary,
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(72)),
                            )),
                        onPressed: !isFlashcardReady
                            ? null
                            : () {
                                showFlashcard();

                                startFlashcardCountdown(DateTime.now().toLocal()
                                    .add(const Duration(seconds: 30)));
                              },
                        child: Text(
                          isFlashcardReady
                              ? 'Buka Flashcard'
                              : formatCountdown(flashcardCountdownDuration),
                          style: Fonts.semibold14,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
