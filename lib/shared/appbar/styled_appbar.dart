import 'package:flutter/material.dart';
import 'package:skripsi_mobile/shared/appbar/appbar_image.dart';
import 'package:skripsi_mobile/theme.dart';

class StyledAppBar {
  static AppBar main({String title = 'home', String img = ''}) {
    return AppBar(
      toolbarHeight: 72,
      title: Row(
        children: [
          const SizedBox(width: 6),
          Text(title, style: Fonts.bold16.copyWith(color: AppColors.dark2)),
        ],
      ),
      actions: [
        Builder(builder: (context) {
          return const Row(
            children: [
              SizedBox(width: 12),
              AppBarImage(36, 36),
              SizedBox(width: 24),
            ],
          );
        })
      ],
      centerTitle: false,
    );
  }
}
