import 'package:flutter/material.dart';
import 'package:skripsi_mobile/theme.dart';

SnackBar popSnackbar(String message, Color color) {
  return SnackBar(
    backgroundColor: color,
    behavior: SnackBarBehavior.floating,
    showCloseIcon: true,
    content: Text(message),
    shape: RoundedRectangleBorder(
        side: BorderSide.none,
        borderRadius: BorderRadius.all(Radius.circular(12))),
    elevation: 24,
  );
}
