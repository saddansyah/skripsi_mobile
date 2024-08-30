import 'package:flutter/material.dart';
import 'package:skripsi_mobile/theme.dart';

class StyledInputDecoration {
  static InputDecoration basic([String? hintText, Icon? suffixIcon]) {
    return InputDecoration(
      isDense: true,
      hintText: hintText ?? '...',
      enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(width: 0, style: BorderStyle.none)),
      focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(
              width: 2,
              style: BorderStyle.solid,
              color: AppColors.greenPrimary)),
      errorBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(
              width: 2, style: BorderStyle.solid, color: AppColors.red)),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(
              width: 2,
              style: BorderStyle.solid,
              color: AppColors.greenPrimary)),
      suffixIcon: suffixIcon,
      suffixIconColor: AppColors.grey,
      border: InputBorder.none,
      filled: true,
      fillColor: AppColors.lightGrey,
      focusColor: AppColors.lightGrey,
    );
  }
}
