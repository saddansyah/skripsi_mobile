import "package:flutter/material.dart";

class AppColors {
  static Color greenPrimary = const Color(0XFF3CA34C);
  static Color greenSecondary = const Color(0XFF67DE81);
  static Color greenAccent = Colors.greenAccent;
  static Color bluePrimary = const Color(0XFF2F85C7);
  static Color blueSecondary = const Color(0XFF57BEF8);
  static Color blueAccent = const Color(0XFFB1D6ED);
  static Color red = const Color(0XFFF06A6A);
  static Color redAccent = Colors.red[200]!;
  static Color amber = const Color(0XFFF5BE1E);
  static Color amberAccent = Colors.amber[200]!;
  static Color dark1 = const Color(0xFF1C1C1C);
  static Color dark2 = const Color(0xFF4A4A4A);
  static Color lightGrey = Colors.grey[300]!;
  static Color grey = const Color(0xFF999798);
  static Color white = const Color(0xFFEDEDED);
}

class Fonts {
  static TextStyle regular12 = const TextStyle(
      fontSize: 12,
      letterSpacing: 0.5,
      fontVariations: [FontVariation('wght', 400)]);
  static TextStyle regular14 = const TextStyle(
      fontSize: 14,
      letterSpacing: 0.5,
      fontVariations: [FontVariation('wght', 400)]);
  static TextStyle semibold14 = const TextStyle(
      fontSize: 14,
      letterSpacing: 0.5,
      fontVariations: [FontVariation('wght', 600)]);
  static TextStyle semibold16 = const TextStyle(
      fontSize: 16,
      letterSpacing: 0.5,
      fontVariations: [FontVariation('wght', 600)]);
  static TextStyle bold16 = const TextStyle(
      fontSize: 16,
      letterSpacing: 0.5,
      fontVariations: [FontVariation('wght', 700)]);
  static TextStyle bold18 = const TextStyle(
      fontSize: 18,
      letterSpacing: 0.5,
      fontVariations: [FontVariation('wght', 700)]);
}

ThemeData getPrimaryTheme(BuildContext context) {
  return ThemeData(
    canvasColor: AppColors.white,
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.greenPrimary),
    scaffoldBackgroundColor: AppColors.white,
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: AppColors.white,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.white,
      foregroundColor: AppColors.dark1,
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
    ),
    fontFamily: 'PlusJakartaSans',
    cardTheme: CardTheme(
      color: Colors.grey[300],
      surfaceTintColor: Colors.transparent,
      elevation: 12,
      shadowColor: Colors.transparent,
      margin: const EdgeInsets.only(bottom: 16),
    ),
  );
}
