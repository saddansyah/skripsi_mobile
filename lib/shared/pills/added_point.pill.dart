import 'package:flutter/material.dart';
import 'package:skripsi_mobile/theme.dart';

class AddedPointPill extends StatelessWidget {
  const AddedPointPill({super.key, required this.point});

  final int point;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 6,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(24)),
        gradient: LinearGradient(
          colors: [AppColors.amber, AppColors.amber.withOpacity(0.8)],
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '+$point',
            style: Fonts.semibold14.copyWith(color: AppColors.dark2),
          ),
          Icon(
            Icons.star_rounded,
            color: AppColors.dark2,
            size: 18,
          ),
        ],
      ),
    );
  }
}
