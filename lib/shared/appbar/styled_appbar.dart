import 'package:flutter/material.dart';
import 'package:skripsi_mobile/shared/appbar/appbar_image.dart';
import 'package:skripsi_mobile/theme.dart';
import 'package:skripsi_mobile/utils/keys.dart';

class StyledAppBar {
  static AppBar main({String title = 'home', String img = ''}) {
    return AppBar(
      toolbarHeight: 72,
      title: Text(title, style: Fonts.semibold16),
      actions: [
        Builder(builder: (context) {
          return const Row(
            children: [
              SizedBox(width: 12),
              AppBarImage(36, 36),
              SizedBox(width: 12),
            ],
          );
        })
      ],
      centerTitle: false,
    );
  }
}
