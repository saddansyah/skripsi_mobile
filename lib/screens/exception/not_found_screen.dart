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
          Container(
            height: 120,
            width: 120,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(24)),
              color: AppColors.lightGrey,
            ),
            child: SvgPicture.asset('assets/svgs/container_icon.svg'),
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
