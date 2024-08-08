import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skripsi_mobile/theme.dart';
import 'package:skripsi_mobile/utils/keys.dart';

extension AsyncValueUI on AsyncValue {
  void showSnackbarOnError(BuildContext context) {
    if (!isLoading && hasError) {
      ScaffoldKeys.snackbarKey.currentState!.showSnackBar(SnackBar(
          backgroundColor: AppColors.red,
          showCloseIcon: true,
          content: Text(error.toString())));
    }
  }
}
