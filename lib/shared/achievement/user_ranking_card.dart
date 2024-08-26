import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skripsi_mobile/models/user.dart';
import 'package:skripsi_mobile/repositories/auth_repository.dart';
import 'package:skripsi_mobile/repositories/profile_repository.dart';
import 'package:skripsi_mobile/theme.dart';

class UserRankingCard extends ConsumerWidget {
  const UserRankingCard({super.key, required this.ranking, required this.user});

  final LeaderboardUser user;
  final int ranking;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final me = ref.watch(profileProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: GestureDetector(
        onTap: () {},
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(24)),
            border: me.value?.id == user.id
                ? Border.all(color: AppColors.greenSecondary, width: 2)
                : Border.all(color: Colors.grey[350]!, width: 1),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: switch (ranking) {
                  1 => AppColors.amber,
                  2 => AppColors.lightGrey,
                  3 => Colors.amber[700],
                  _ => AppColors.white
                },
                child: Text(ranking.toString(), style: Fonts.regular14),
              ),
              SizedBox(width: 12),
              CircleAvatar(
                backgroundImage: NetworkImage(user.img),
                backgroundColor: AppColors.lightGrey,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Text(
                            user.name,
                            style: Fonts.regular14,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            softWrap: true,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(24)),
                            gradient: LinearGradient(
                              colors: [
                                AppColors.greenSecondary,
                                AppColors.greenSecondary.withOpacity(0.8)
                              ],
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.star_rounded,
                                color: AppColors.dark2,
                                size: 18,
                              ),
                              Text(
                                user.totalPoint.toString(),
                                style: Fonts.semibold14
                                    .copyWith(color: AppColors.dark2),
                              ),
                            ],
                          ),
                        ),
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
  }
}
