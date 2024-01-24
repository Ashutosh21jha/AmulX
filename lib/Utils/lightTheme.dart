import 'package:flutter/material.dart';
import './AppColors.dart';
import './darkTheme.dart';

ThemeData lightThemeData = ThemeData.light(useMaterial3: true)
    .copyWith(extensions: <ThemeExtension<AppColors2>>[
  AppColors2(
    text1: Color(0xFF57585B),
    text2: Color(0xFF414042),
    text3: AppColors.green,
    text4: AppColors.yellow,
  )
]);
