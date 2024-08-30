import 'package:flutter/material.dart';
import 'package:skripsi_mobile/theme.dart';
import 'package:skripsi_mobile/utils/constants/enums.dart';

class ContainerTypePill extends StatelessWidget {
  const ContainerTypePill(
      {super.key, required this.type, this.fontSize = 12, this.iconSize = 16});

  final ContainerType type;
  final double fontSize;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: switch (type) {
          ContainerType.depo => AppColors.greenAccent,
          ContainerType.tong => AppColors.blueAccent,
          ContainerType.other => AppColors.lightGrey,
        },
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: Wrap(
        spacing: 3,
        children: [
          Icon(
            Icons.delete_rounded,
            size: iconSize,
            color: switch (type) {
              ContainerType.depo => AppColors.greenPrimary,
              ContainerType.tong => AppColors.bluePrimary,
              ContainerType.other => AppColors.grey,
            },
          ),
          Text(
            type.value,
            style: Fonts.semibold14.copyWith(
                fontSize: fontSize,
                color: switch (type) {
                  ContainerType.depo => AppColors.greenPrimary,
                  ContainerType.tong => AppColors.bluePrimary,
                  ContainerType.other => AppColors.grey,
                }),
          )
        ],
      ),
    );
  }
}
