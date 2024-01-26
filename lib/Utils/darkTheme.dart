import 'package:flutter/material.dart';
import './AppColors.dart';

ThemeData darkThemeData() {
  return ThemeData.dark(useMaterial3: true)
      .copyWith(extensions: <ThemeExtension<AppColors2>>[
    AppColors2(
        text1: Colors.white60,
        text2: Colors.white70,
        borderColor: Colors.white38,
        cardColor: Colors.white10,
        whiteText: Colors.white70,
        scaffoldBackgroundColor: ThemeData.dark().scaffoldBackgroundColor)
  ]);
}
