import 'package:amul/Utils/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showAuthErrorSnackBar(String title, String message) {
  Get.snackbar(
    title,
    message,
    barBlur: 1,
    backgroundGradient: const LinearGradient(
      colors: [
        Color(0xFFF98181),
        AppColors.red,
        Color(0xFF850000),
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
    duration: const Duration(seconds: 3),
    icon: Image.asset(
      'assets/images/icon.png',
      width: 24,
      height: 24,
    ),
  );
}

void showAuthSuccessSnackBar(String title, String message) {
  Get.snackbar(
    title,
    message,
    barBlur: 1,
    backgroundGradient: const LinearGradient(
      colors: [
        Color(0xFFA2E8D8),
        AppColors.green,
        Color(0xFF007A52),
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
    duration: const Duration(seconds: 3),
    icon: Image.asset(
      'assets/images/icon.png',
      width: 24,
      height: 24,
    ),
  );
}
