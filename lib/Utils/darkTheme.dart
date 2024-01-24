import 'package:flutter/material.dart';
import './AppColors.dart';

ThemeData darkThemeData = ThemeData.dark(useMaterial3: true)
    .copyWith(extensions: <ThemeExtension<AppColors2>>[
  AppColors2(
    text1: Colors.white70,
    text2: Colors.white70,
    text3: AppColors.green,
    text4: AppColors.yellow,
  )
]);
