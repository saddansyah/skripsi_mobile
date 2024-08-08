import 'package:flutter/material.dart';
import 'package:skripsi_mobile/screens/mission/collect/collect_detail_screen.dart';
import 'package:skripsi_mobile/screens/models/collect.dart';
import 'package:skripsi_mobile/theme.dart';
import 'package:skripsi_mobile/utils/constants/enums.dart';

class CollectCard extends StatelessWidget {
  const CollectCard({super.key, required this.collect});

  final Collect collect;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
              builder: (_) => CollectDetailScreen(id: collect.id)));
        },
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(24)),
            border: Border.all(color: Colors.grey[350]!, width: 1),
          ),
          child: Row(
            children: [
              Hero(
                tag: collect.id,
                child: Container(
                  height: 72,
                  width: 72,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      color: AppColors.lightGrey),
                  child: Image.network(
                    collect.img,
                    fit: BoxFit.fill,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return CircularProgressIndicator(
                        color: AppColors.greenPrimary,
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      );
                    },
                  ),
                ),
              ),
              SizedBox(width: 12),
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
                              EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                          decoration: BoxDecoration(
                            color: switch (collect.status) {
                              Status.accepted => AppColors.greenAccent,
                              Status.pending => AppColors.lightGrey,
                              Status.rejected => AppColors.red,
                            },
                            borderRadius: BorderRadius.all(Radius.circular(12)),
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
                          Icons.apartment_rounded,
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
                              '${collect.createdAt}',
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
