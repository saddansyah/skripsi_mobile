import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:skripsi_mobile/repositories/achievement_repository.dart';
import 'package:skripsi_mobile/screens/exception/error_screen.dart';
import 'package:skripsi_mobile/screens/exception/not_found_screen.dart';
import 'package:skripsi_mobile/theme.dart';

class AchievementListScreen extends ConsumerWidget {
  const AchievementListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myAchievements = ref.watch(myAchievementsProvider);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 72,
        title: Text('Semua Capaianmu', style: Fonts.semibold16),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Column(
            children: [
              myAchievements.when(
                data: (a) {
                  return a.isEmpty
                      ? const NotFoundScreen(message: 'Tidak ada data')
                      : ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: a.length,
                          itemBuilder: (context, i) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: GestureDetector(
                                onTap: () {},
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(24)),
                                    border: Border.all(
                                        color: Colors.grey[350]!, width: 1),
                                  ),
                                  child: Row(
                                    children: [
                                      Text(a[i].id.toString(),
                                          style: Fonts.regular14
                                              .copyWith(color: AppColors.grey)),
                                      const SizedBox(width: 12),
                                      CircleAvatar(
                                        radius: 30,
                                        backgroundImage: NetworkImage(a[i].img),
                                        backgroundColor: AppColors.white,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    a[i].name,
                                                    style: Fonts.semibold14,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                    softWrap: true,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 6),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    a[i].description,
                                                    style: Fonts.regular12,
                                                  ),
                                                )
                                              ],
                                            ),
                                            const SizedBox(height: 6),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    'Dicapai: ${DateFormat('dd/MM/yyyy').format(a[i].createdAt.toLocal())}',
                                                    style: Fonts.regular12
                                                        .copyWith(
                                                            color:
                                                                AppColors.grey),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                    softWrap: true,
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                },
                error: (e, _) => ErrorScreen(
                  buttonText: 'Muat Ulang',
                  message: e.toString(),
                  isRefreshing: myAchievements.isRefreshing,
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
