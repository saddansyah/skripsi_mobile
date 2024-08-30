import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skripsi_mobile/models/container.dart' as model;
import 'package:skripsi_mobile/screens/mission/container/container_detail_screen.dart';
import 'package:skripsi_mobile/shared/pills/container_type_pill.dart';
import 'package:skripsi_mobile/theme.dart';
import 'package:skripsi_mobile/utils/constants/enums.dart';

class ContainerCard extends StatelessWidget {
  const ContainerCard({
    super.key,
    required this.container,
    this.isStatusShowed = false,
    required this.distance,
  });

  final bool isStatusShowed;
  final model.Container container;
  final String distance;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
              builder: (_) => ContainerDetailScreen(id: container.id)));
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
                padding: const EdgeInsets.all(6),
                height: 72,
                width: 72,
                clipBehavior: Clip.hardEdge,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                child: SvgPicture.asset(
                  'assets/svgs/container_icon.svg',
                ),
              ),
              const SizedBox(width: 12),
              Wrap(
                direction: Axis.vertical,
                spacing: 6,
                children: [
                  Row(
                    children: [
                      Text(container.name, style: Fonts.regular14),
                    ],
                  ),
                  Row(
                    children: [
                      ContainerTypePill(type: container.type),
                      const SizedBox(width: 6),
                      isStatusShowed
                          ? Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 3),
                              decoration: BoxDecoration(
                                color: switch (container.status) {
                                  Status.accepted => AppColors.greenAccent,
                                  Status.pending => AppColors.lightGrey,
                                  Status.rejected => AppColors.red,
                                },
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(12)),
                              ),
                              child: Text(
                                container.status.value,
                                style: Fonts.regular12.copyWith(
                                  color: switch (container.status) {
                                    Status.accepted => AppColors.greenPrimary,
                                    Status.pending => AppColors.grey,
                                    Status.rejected => Colors.red[600],
                                  },
                                ),
                              ),
                            )
                          : const SizedBox()
                    ],
                  ),
                  Row(
                    children: [
                      Wrap(
                        spacing: 3,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Icon(
                            Icons.star,
                            size: 16,
                            color: AppColors.amber,
                          ),
                          Text(
                            '${container.rating} (${container.ratingCount})',
                            style: Fonts.regular14
                                .copyWith(fontSize: 12, color: AppColors.grey),
                          )
                        ],
                      ),
                      const SizedBox(width: 6),
                      Wrap(
                        spacing: 3,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Icon(
                            Icons.location_pin,
                            size: 16,
                            color: AppColors.grey,
                          ),
                          Text(
                            distance,
                            style: Fonts.regular14
                                .copyWith(fontSize: 12, color: AppColors.grey),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
