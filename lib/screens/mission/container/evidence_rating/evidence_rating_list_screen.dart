import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:skripsi_mobile/models/container.dart' hide Container;
import 'package:skripsi_mobile/repositories/achievement_repository.dart';
import 'package:skripsi_mobile/repositories/evidence_rating_repository.dart';
import 'package:skripsi_mobile/screens/exception/error_screen.dart';
import 'package:skripsi_mobile/screens/exception/not_found_screen.dart';
import 'package:skripsi_mobile/theme.dart';

class EvidenceRatingListScreen extends ConsumerWidget {
  const EvidenceRatingListScreen({super.key, required this.container});

  final DetailedContainer container;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ratings = ref.watch(evidenceRatingsProvider(container.id));

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 72,
        title: Text('Semua Rating dari ${container.name}',
            style: Fonts.semibold16),
        centerTitle: false,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
        child: SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Column(
            children: [
              ratings.when(
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
                                      CircleAvatar(
                                        radius: 30,
                                        backgroundImage: NetworkImage(a[i]
                                                .isAnonim
                                            ? 'https://clipart-library.com/images/ATbrxjpyc.jpg'
                                            : a[i].userImage),
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
                                                    a[i].isAnonim
                                                        ? 'Pengguna'
                                                        : a[i].userName,
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
                                            RatingBar(
                                              itemSize: 16,
                                              minRating: 0,
                                              maxRating: 5,
                                              allowHalfRating: false,
                                              initialRating:
                                                  a[i].value.toDouble(),
                                              ratingWidget: RatingWidget(
                                                  full: Icon(
                                                    Icons.star_rounded,
                                                    color: AppColors.amber,
                                                  ),
                                                  half: Icon(
                                                    Icons.star_half_rounded,
                                                    color: AppColors.amber,
                                                  ),
                                                  empty: Icon(
                                                    Icons.star_outline_rounded,
                                                    color: AppColors.amber,
                                                  )),
                                              onRatingUpdate: (_) {},
                                            ),
                                            const SizedBox(height: 6),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    a[i].info,
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
                                                    'Dibuat: ${DateFormat('dd/MM/yyyy').format(a[i].createdAt.toLocal())}',
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
                  isRefreshing: ratings.isRefreshing,
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
