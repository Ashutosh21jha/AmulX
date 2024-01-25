import 'package:flutter/material.dart';
import './AppColors.dart';

ThemeData lightThemeData() {
  return ThemeData.light(useMaterial3: true)
      .copyWith(extensions: <ThemeExtension<AppColors2>>[
    AppColors2(
      text1: Color(0xFF57585B),
      // text1: Color(0xFF57585B),
      text2: Colors.black,
      // text2: Color(0xFF414042),
      borderColor: Colors.grey,
      cardColor: Colors.white,
      whiteText: Colors.white,
      scaffoldBackgroundColor: Colors.grey.shade200,
    )
  ]);
}
