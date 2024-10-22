import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skripsi_mobile/theme.dart';

enum SnackBarType { error, info, success }

SnackBar popSnackbar(String message, SnackBarType type,
    [Widget? leading, Duration? duration]) {
  return SnackBar(
    duration: duration ?? const Duration(seconds: 3),
    backgroundColor: switch (type) {
      SnackBarType.success => AppColors.greenPrimary,
      SnackBarType.info => AppColors.bluePrimary,
      SnackBarType.error => AppColors.red,
    },
    behavior: SnackBarBehavior.floating,
    showCloseIcon: true,
    content: Row(
      children: [
        SizedBox(
          height: 48,
          width: 48,
          child: Center(
            child: leading ??
                // TODO -> Change SVG
                SvgPicture.asset(
                  type == SnackBarType.error
                      ? 'assets/svgs/icon_maskot-not-found.svg'
                      : 'assets/svgs/icon_maskot-head.svg',
                  height: 36,
                  width: 36,
                ),
          ),
        ),
        const SizedBox(width: 18),
        Expanded(
          child: Text(
            message,
            style: Fonts.semibold14,
          ),
        ),
      ],
    ),
    shape: const RoundedRectangleBorder(
        side: BorderSide.none,
        borderRadius: BorderRadius.all(Radius.circular(12))),
    elevation: 24,
  );
}
