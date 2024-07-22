import 'package:amul/Utils/darkTheme.dart';
import 'package:amul/Utils/lightTheme.dart';
import 'package:amul/controllers/amul_status_controller.dart';
import 'package:amul/controllers/user_controller.dart';
import 'package:amul/screens/splashscreen.dart';
import 'package:amul/services/notification_service.dart';
import 'package:amul/services/remote_config_service.dart';
import 'package:amul/services/shared_prefs_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:logger/web.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  Get.put(Logger());

  final NotificationService notificationService = NotificationService();
  notificationService.requestPermission();
  notificationService.getDeviceToken();
  notificationService.firebaseInit();

  final RemoteConfigService remoteConfigService = RemoteConfigService();
  await remoteConfigService.initialize();

  final AmulXStatusController amulXStatusController = AmulXStatusController();

  Get.put(remoteConfigService);
  Get.put(notificationService);
  Get.put(amulXStatusController);
  Get.put(SharedPrefsService());
  Get.put(UserController());

  final isDarkMode = await Get.find<SharedPrefsService>().isDarkTheme();

  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    theme: lightThemeData(),
    darkTheme: darkThemeData(),
    themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
    home: const SplashScreen(),
  ));
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  if (kDebugMode) {
    print(message.notification!.title);
  }
}
