import 'package:flutter/material.dart';
import 'package:skripsi_mobile/theme.dart';
import 'package:skripsi_mobile/utils/constants/enums.dart';

class WasteTypePill extends StatelessWidget {
  const WasteTypePill(
      {super.key, required this.type, this.fontSize = 12, this.iconSize = 16});

  final WasteType type;
  final double fontSize;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: switch (type) {
          WasteType.b3 => AppColors.redAccent,
          WasteType.organik => AppColors.greenAccent,
          WasteType.gunaUlang => AppColors.amberAccent,
          WasteType.daurUlang => AppColors.blueAccent,
          WasteType.residu => AppColors.lightGrey,
          WasteType.mixed => AppColors.lightGrey,
        },
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: Wrap(
        spacing: 3,
        children: [
          Icon(
            Icons.cached_rounded,
            size: iconSize,
            color: switch (type) {
              WasteType.b3 => AppColors.red,
              WasteType.organik => AppColors.greenPrimary,
              WasteType.gunaUlang => AppColors.red,
              WasteType.daurUlang => AppColors.bluePrimary,
              WasteType.residu => AppColors.grey,
              WasteType.mixed => AppColors.grey,
            },
          ),
          Text(
            type.value,
            style: Fonts.semibold14.copyWith(
                fontSize: fontSize,
                color: switch (type) {
                  WasteType.b3 => AppColors.red,
                  WasteType.organik => AppColors.greenPrimary,
                  WasteType.gunaUlang => AppColors.red,
                  WasteType.daurUlang => AppColors.bluePrimary,
                  WasteType.residu => AppColors.grey,
                  WasteType.mixed => AppColors.grey,
                }),
          )
        ],
      ),
    );
  }
}
