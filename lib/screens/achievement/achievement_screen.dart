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
        child: RefreshIndicator(
          onRefresh: () async {
            await ref.refresh(leaderboardUsersProvider.future);
            await ref.refresh(profileProvider.future);
            await ref.refresh(myAchievementsProvider.future);
          },
          child: SingleChildScrollView(
            physics: const ScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
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
                          const Spacer(),
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
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(24)),
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
                                const SizedBox(width: 6),
                                Text(
                                  '${my.hasError ? '-' : (my.value?.totalPoint ?? 0)}',
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
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
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
                            style: Fonts.semibold14
                                .copyWith(color: AppColors.white),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/svgs/container_icon.svg',
                            height: 60,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              my.value?.rank ?? 'Title Kamu',
                              style: Fonts.bold18.copyWith(
                                  color: AppColors.white, fontSize: 24),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 24),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '⭐${my.hasError ? '-' : (my.value?.totalPoint ?? 0)}/⭐${my.hasError ? '-' : (my.value?.nextPoint ?? 0)}',
                                style: Fonts.semibold14
                                    .copyWith(color: AppColors.white),
                              ),
                              Text(
                                my.hasError ? '-' : my.value?.nextRank ?? '...',
                                style: Fonts.semibold14
                                    .copyWith(color: AppColors.white),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          LinearProgressIndicator(
                            minHeight: 20,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(24)),
                            backgroundColor: AppColors.amber.withOpacity(0.2),
                            color: AppColors.amberAccent,
                            value: (my.value?.totalPoint ?? 0) /
                                ((my.value?.nextPoint ?? 0) +
                                    (my.value?.totalPoint ?? 0)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
                  decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(24)),
                      border: Border.all(color: Colors.grey[350]!)),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text('Capaian Terbaru',
                              style: Fonts.semibold16
                                  .copyWith(color: AppColors.dark2)),
                          const Spacer(),
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
                      const SizedBox(height: 12),
                      myAchievements.when(
                        data: (a) {
                          return a.isEmpty
                              ? const NotFoundScreen(message: 'Tidak ada data')
                              : GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: a.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          crossAxisSpacing: 12,
                                          mainAxisSpacing: 12,
                                          mainAxisExtent: 160),
                                  itemBuilder: (c, i) => Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      children: [
                                        CircleAvatar(
                                            radius: 36,
                                            backgroundImage:
                                                NetworkImage(a[i].img)),
                                        const SizedBox(height: 6),
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
                const SizedBox(height: 24),
                Text(
                  'Ranking',
                  style: Fonts.semibold16,
                ),
                const SizedBox(height: 12),
                leaderboardUsers.when(
                  data: (l) {
                    return l.isEmpty
                        ? const NotFoundScreen(message: 'Tidak ada data')
                        : ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: l.length,
                            itemBuilder: (context, i) {
                              return UserRankingCard(user: l[i]);
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
                    child: CircularProgressIndicator(
                        color: AppColors.greenPrimary),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
