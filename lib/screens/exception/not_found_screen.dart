import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skripsi_mobile/theme.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/svgs/icon_maskot-not-found.svg',
            height: 160,
          ),
          const SizedBox(height: 24),
          Wrap(
            direction: Axis.vertical,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 6,
            children: [
              Text('Ups :(',
                  style: Fonts.bold18.copyWith(color: AppColors.grey)),
              Text(message,
                  style: Fonts.regular14.copyWith(color: AppColors.grey)),
            ],
          ),
        ],
      ),
    );
  }
}
