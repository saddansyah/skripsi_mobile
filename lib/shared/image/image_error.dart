import 'package:flutter/material.dart';
import 'package:skripsi_mobile/theme.dart';

class ImageError extends StatelessWidget {
  const ImageError({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.lightGrey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.sentiment_dissatisfied_rounded, color: AppColors.grey),
          Icon(Icons.image_not_supported_rounded, color: AppColors.grey),
        ],
      ),
    );
  }
}
