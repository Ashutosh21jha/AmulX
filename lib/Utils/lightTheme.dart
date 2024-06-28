import 'package:flutter/material.dart';
import './AppColors.dart';

ThemeData lightThemeData() {
  return ThemeData.light(useMaterial3: true)
      .copyWith(extensions: <ThemeExtension<AppColors2>>[
    AppColors2(
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      primary: const Color(0xFF2546A9),
      secondary: const Color(0xFF18AE86),
      surfaceColor: Colors.white,
      secondaryText: const Color(0xFF57585B),
      primaryText: Colors.black,
      backgroundColor: Colors.grey.shade200,
      blue: const Color(0xFF2546A9),
    )
  ]);
}
