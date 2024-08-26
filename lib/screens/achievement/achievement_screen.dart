import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skripsi_mobile/repositories/achievement_repository.dart';
import 'package:skripsi_mobile/repositories/profile_repository.dart';
import 'package:skripsi_mobile/screens/achievement/achievement_list_screen.dart';
import 'package:skripsi_mobile/screens/exception/error_screen.dart';
import 'package:skripsi_mobile/screens/exception/not_found_screen.dart';
import 'package:skripsi_mobile/shared/achievement/user_ranking_card.dart';
import 'package:skripsi_mobile/shared/appbar/styled_appbar.dart';
import 'package:skripsi_mobile/theme.dart';

class AchievementScreen extends ConsumerStatefulWidget {
  const AchievementScreen({super.key});

  @override
  ConsumerState<AchievementScreen> createState() => _AchievementScreenState();
}

class _AchievementScreenState extends ConsumerState<AchievementScreen> {
  @override
  Widget build(BuildContext context) {
    final leaderboardUsers = ref.watch(leaderboardUsersProvider);
    final my = ref.watch(profileProvider);
    final myAchievements = ref.watch(myAchievementsProvider);

    return Scaffold(
      appBar: StyledAppBar.main(title: 'Capaian'),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        child: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(24),
                  ),
                  gradient: LinearGradient(colors: [
                    AppColors.greenPrimary,
                    Colors.green[700]!,
                  ]),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text('Poin kamu:',
                            style: Fonts.semibold16
                                .copyWith(color: AppColors.white)),
                        Spacer(),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.keyboard_arrow_right_rounded,
                              color: AppColors.white),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(24)),
                            gradient: LinearGradient(
                              colors: [
                                AppColors.amber,
                                AppColors.amber.withOpacity(0.8)
                              ],
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.star_rounded,
                                color: AppColors.dark2,
                                size: 36,
                              ),
                              SizedBox(width: 6),
                              Text(
                                my.value?.totalPoint.toString() ?? '0',
                                style: Fonts.bold18.copyWith(
                                    color: AppColors.dark2, fontSize: 24),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(24),
                  ),
                  gradient: LinearGradient(colors: [
                    AppColors.blueSecondary,
                    Colors.blue[400]!,
                  ]),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'Title kamu:',
                          style:
                              Fonts.semibold14.copyWith(color: AppColors.white),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/svgs/container_icon.svg',
                          height: 60,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            my.value?.rank ?? 'Title Kamu',
                            style: Fonts.bold18
                                .copyWith(color: AppColors.white, fontSize: 24),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Kumpulkan ${my.value?.nextPoint ?? '-'} poin lagi untuk menjadi ${my.value?.nextRank ?? '-'}!',
                            style: Fonts.regular12
                                .copyWith(color: AppColors.white),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
                decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.all(Radius.circular(24)),
                    border: Border.all(color: Colors.grey[350]!)),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text('Capaian Terbaru',
                            style: Fonts.semibold16
                                .copyWith(color: AppColors.dark2)),
                        Spacer(),
                        IconButton(
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true).push(
                              MaterialPageRoute(
                                builder: (_) => const AchievementListScreen(),
                              ),
                            );
                          },
                          icon: Icon(Icons.keyboard_arrow_right_rounded,
                              color: AppColors.dark2),
                        )
                      ],
                    ),
                    SizedBox(height: 12),
                    myAchievements.when(
                      data: (a) {
                        return a.isEmpty
                            ? NotFoundScreen(message: 'Tidak ada data')
                            : GridView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: a.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        crossAxisSpacing: 12,
                                        mainAxisSpacing: 12,
                                        mainAxisExtent: 160),
                                itemBuilder: (c, i) => Padding(
                                  padding: EdgeInsets.all(12),
                                  child: Column(
                                    children: [
                                      CircleAvatar(
                                          radius: 36,
                                          backgroundImage:
                                              NetworkImage(a[i].img)),
                                      SizedBox(height: 6),
                                      Text(
                                        a[i].name,
                                        style: Fonts.regular12,
                                        textAlign: TextAlign.center,
                                      )
                                    ],
                                  ),
                                ),
                              );
                      },
                      error: (e, _) => ErrorScreen(
                        buttonText: 'Muat Ulang',
                        message: e.toString(),
                        isRefreshing: leaderboardUsers.isRefreshing,
                        onPressed: () {
                          ref.invalidate(leaderboardUsersProvider);
                        },
                      ),
                      loading: () => Center(
                        child: CircularProgressIndicator(
                            color: AppColors.greenPrimary),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              Text(
                'Ranking',
                style: Fonts.semibold16,
              ),
              SizedBox(height: 12),
              leaderboardUsers.when(
                data: (l) {
                  return l.isEmpty
                      ? NotFoundScreen(message: 'Tidak ada data')
                      : ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: l.length,
                          itemBuilder: (context, i) {
                            return UserRankingCard(user: l[i], ranking: i + 1);
                          },
                        );
                },
                error: (e, _) => ErrorScreen(
                  buttonText: 'Muat Ulang',
                  message: e.toString(),
                  isRefreshing: leaderboardUsers.isRefreshing,
                  onPressed: () {
                    ref.invalidate(leaderboardUsersProvider);
                  },
                ),
                loading: () => Center(
                  child:
                      CircularProgressIndicator(color: AppColors.greenPrimary),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
