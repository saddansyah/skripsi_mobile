import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:skripsi_mobile/screens/mission/collect/collect_detail_screen.dart';
import 'package:skripsi_mobile/models/collect.dart';
import 'package:skripsi_mobile/shared/image/image_with_token.dart';
import 'package:skripsi_mobile/theme.dart';
import 'package:skripsi_mobile/utils/constants/enums.dart';

class CollectCard extends ConsumerWidget {
  const CollectCard({super.key, required this.collect});

  final Collect collect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
              builder: (_) => CollectDetailScreen(id: collect.id)));
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(24)),
            border: Border.all(color: Colors.grey[350]!, width: 1),
          ),
          child: Row(
            children: [
              Container(
                height: 72,
                width: 72,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    color: AppColors.lightGrey),
                child: ImageWithToken(collect.img),
              ),
              const SizedBox(width: 12),
              Flexible(
                child: Wrap(
                  direction: Axis.vertical,
                  spacing: 6,
                  children: [
                    Text('Sampah ID #${collect.id}', style: Fonts.regular14),
                    Wrap(
                      spacing: 6,
                      children: [
                        Container(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                          decoration: BoxDecoration(
                            color: switch (collect.status) {
                              Status.accepted => AppColors.greenAccent,
                              Status.pending => AppColors.lightGrey,
                              Status.rejected => AppColors.red,
                            },
                            borderRadius: const BorderRadius.all(Radius.circular(12)),
                          ),
                          child: Text(
                            collect.status.value,
                            style: Fonts.regular12.copyWith(
                              color: switch (collect.status) {
                                Status.accepted => AppColors.greenPrimary,
                                Status.pending => AppColors.grey,
                                Status.rejected => Colors.red[600],
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    Wrap(
                      spacing: 3,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Icon(
                          Icons.location_pin,
                          size: 16,
                          color: AppColors.bluePrimary,
                        ),
                        Text(
                          collect.containerName,
                          style: Fonts.semibold14.copyWith(
                              fontSize: 12, color: AppColors.bluePrimary),
                        )
                      ],
                    ),
                    Wrap(
                      spacing: 12,
                      children: [
                        Wrap(
                          spacing: 3,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Icon(
                              Icons.date_range_rounded,
                              size: 16,
                              color: AppColors.dark2,
                            ),
                            Text(
                              DateFormat('yyyy/MM/dd')
                                  .format(collect.createdAt.toLocal()),
                              style: Fonts.regular12
                                  .copyWith(color: AppColors.grey),
                            )
                          ],
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
