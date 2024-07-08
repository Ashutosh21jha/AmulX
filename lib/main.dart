import 'package:amul/Utils/darkTheme.dart';
import 'package:amul/Utils/lightTheme.dart';
import 'package:amul/controllers/user_controller.dart';
import 'package:amul/screens/splashscreen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:logger/web.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseMessaging.instance.requestPermission();

  final UserController userController = Get.put(UserController());
  final logger = Get.put(Logger());

  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    theme: lightThemeData(),
    darkTheme: darkThemeData(),
    themeMode: ThemeMode.dark,
    home: const SplashScreen(),
  ));
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
//       statusBarColor: Colors.transparent,
//       statusBarIconBrightness: Brightness.dark,
//     ));
//     return AdaptiveTheme(
//       light: lightThemeData(),
//       dark: darkThemeData(),
//       initial: AdaptiveThemeMode.light,
//       builder: (lightTheme, darkTheme) => GetMaterialApp(
//         debugShowCheckedModeBanner: false,
//         theme: lightTheme,
//         darkTheme: darkTheme,
//         // themeMode: ThemeMode.dark,
//         home: const SplashScreen(),
//       ),
//     );
//   }
// }
