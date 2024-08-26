import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skripsi_mobile/shared/snackbar/snackbar.dart';
import 'package:skripsi_mobile/theme.dart';
import 'package:skripsi_mobile/utils/keys.dart';

extension AsyncValueUI on AsyncValue {
  void showErrorSnackbar(BuildContext context, [String? message]) {
    ScaffoldKeys.snackbarKey.currentState!.removeCurrentSnackBar();
    ScaffoldKeys.snackbarKey.currentState!.showSnackBar(
        popSnackbar(message ?? error.toString(), SnackBarType.error));
  }

  void showSnackbar(BuildContext context, String message) {
    ScaffoldKeys.snackbarKey.currentState!.removeCurrentSnackBar();
    ScaffoldKeys.snackbarKey.currentState!
        .showSnackBar(popSnackbar(message, SnackBarType.success));
  }

  void showLoadingSnackbar(BuildContext context, String message) {
    ScaffoldKeys.snackbarKey.currentState!.removeCurrentSnackBar();
    ScaffoldKeys.snackbarKey.currentState!.showSnackBar(popSnackbar(
        message,
        SnackBarType.info,
        CircularProgressIndicator(color: AppColors.white),
        const Duration(seconds: 30)));
  }
}
