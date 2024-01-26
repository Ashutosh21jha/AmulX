import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:amul/Utils/darkTheme.dart';
import 'package:amul/Utils/lightTheme.dart';
import 'package:amul/screens/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
    return AdaptiveTheme(
      light: lightThemeData(),
      dark: darkThemeData(),
      initial: AdaptiveThemeMode.dark,
      builder: (lightTheme, darkTheme) => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.dark,
        home: SplashScreen(),
      ),
    );
  }
}
