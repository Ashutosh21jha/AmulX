import 'package:amul/Utils/AppColors.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class AmulXSnackBars {
  static void showAuthSuccessSnackBar(String title, String message) {
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

  static void showEmptyCartPleaseAddItemSnackbar() {
    Get.snackbar(
      'Cart is Empty',
      'Please add items to the cart first',
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

  static void showNameSuccessfullyChangedSnackbar() {
    Get.snackbar(
      'Success',
      'Name Updated',
      barBlur: 10,
      backgroundGradient: const LinearGradient(
        colors: [
          Color(0xFFA2E8D8),
          AppColors.green,
          Color(0xFF007A52),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      duration: const Duration(seconds: 1),
      icon: Image.asset(
        'assets/images/icon.png',
        width: 24,
        height: 24,
      ),
    );
  }

  static void showProfileImageSuccessfullyChangedSnackbar() {
    Get.snackbar(
      'Success',
      'Profile Image Updated',
      barBlur: 10,
      backgroundGradient: const LinearGradient(
        colors: [
          Color(0xFFA2E8D8),
          AppColors.green,
          Color(0xFF007A52),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      duration: const Duration(seconds: 1),
      icon: Image.asset(
        'assets/images/icon.png',
        width: 24,
        height: 24,
      ),
    );
  }

  static void showAuthErrorSnackBar(String title, String message) {
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

  static void onPasswordResetAccountNotFoundSnackbar() {
    Get.snackbar(
      'You do not have account yet!',
      'Sign Up using Nsut credentials',
      backgroundGradient: const LinearGradient(
        colors: [
          Color(0xFF00084B),
          Color(0xFF2E55C0),
          Color(0xFF148BFA),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      duration: const Duration(seconds: 2),
      barBlur: 10,
      icon: Image.asset(
        'assets/images/icon.png',
        width: 24,
        height: 24,
      ),
    );
  }

  static void showPasswordResetLinkSendSnackbar() {
    Get.snackbar(
      'Password Reset link Sent!',
      'Thank You for using Amul',
      backgroundGradient: const LinearGradient(
        colors: [
          Color(0xFF00084B),
          Color(0xFF2E55C0),
          Color(0xFF148BFA),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      duration: const Duration(seconds: 2),
      barBlur: 10,
      icon: Image.asset(
        'assets/images/icon.png',
        width: 24,
        height: 24,
      ),
    );
  }

  static void showPaymentOrderSuccessSnackbar() {
    Get.snackbar(
      'Payment Successful',
      'Thank You for using Amul',
      backgroundGradient: const LinearGradient(
        colors: [
          Color(0xFFA2E8D8),
          AppColors.green,
          Color(0xFF007A52),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      duration: const Duration(seconds: 1),
      barBlur: 10,
      icon: Image.asset(
        'assets/images/icon.png',
        width: 24,
        height: 24,
      ),
    );
  }

  static void showManualOrderCreationFailedSnackbar() {
    Get.snackbar(
      'Order creation failed',
      'please contact AMULX',
      barBlur: 10,
      backgroundGradient: const LinearGradient(
        colors: [
          Color(0xFFF98181),
          AppColors.red,
          Color(0xFF850000),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      duration: const Duration(seconds: 1),
      icon: Image.asset(
        'assets/images/icon.png',
        width: 24,
        height: 24,
      ),
    );
  }

  static void showPaymentOrderFailureSnackbar() {
    Get.snackbar(
      'Payment Failed',
      'Please Try Again',
      barBlur: 10,
      backgroundGradient: const LinearGradient(
        colors: [
          Color(0xFFF98181),
          AppColors.red,
          Color(0xFF850000),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      duration: const Duration(seconds: 1),
      icon: Image.asset(
        'assets/images/icon.png',
        width: 24,
        height: 24,
      ),
    );
  }

  static void showPaymentOrderPendingSnackbar() {
    Get.snackbar(
      'Payment Pending',
      'Please wait for the payment to be processed',
      barBlur: 10,
      backgroundGradient: const LinearGradient(
        colors: [
          Color(0xFFA2E8D8),
          AppColors.green,
          Color(0xFF007A52),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      duration: const Duration(seconds: 1),
      icon: Image.asset(
        'assets/images/icon.png',
        width: 24,
        height: 24,
      ),
    );
  }

  static void showItemOutOfStockSnackbar(List<String> items) {
    items = items.map((item) => "'$item'").toList();
    Get.snackbar(
      'Stock Exceeded',
      'Reduce quantity for ${items.join(', ')}',
      barBlur: 10,
      backgroundGradient: const LinearGradient(
        colors: [
          Color(0xFFF98181),
          AppColors.red,
          Color(0xFF850000),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      duration: const Duration(seconds: 1),
      icon: Image.asset(
        'assets/images/icon.png',
        width: 24,
        height: 24,
      ),
    );
  }
}
