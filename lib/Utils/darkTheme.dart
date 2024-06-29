import 'package:flutter/material.dart';
import './AppColors.dart';

ThemeData darkThemeData() {
  return ThemeData.dark(useMaterial3: true)
      .copyWith(extensions: <ThemeExtension<AppColors2>>[
    AppColors2(
        backgroundColor: const Color(0xFF121212),
        surfaceColor: const Color(0xFF282828),
        primary: const Color(0xFF2546A9),
        onPrimary: Colors.white,
        secondary: const Color(0xFF18AE86),
        onSecondary: Colors.white,
        primaryText: const Color(0xFFFFFFFF),
        secondaryText: const Color(0xFFB3B3B3),
        blue: const Color(0xFF2546A9),
        green: const Color(0xFF18AE86))
  ]);
}
