import 'dart:async';
import 'package:amul/controllers/items_controller.dart';
import 'package:amul/controllers/user_controller.dart';
import 'package:amul/screens/auth/emailverification.dart';
import 'package:amul/screens/auth/login_page.dart';
import 'package:amul/screens/mainscreen.dart';
import 'package:amul/services/notification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

final auth = FirebaseAuth.instance;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _Splashscreenstate createState() => _Splashscreenstate();
}

class _Splashscreenstate extends State<SplashScreen> {
  double _imageOffset = 0.0;
  bool _animationStarted = false;

  @override
  void initState() {
    super.initState();

    Get.find<NotificationService>().initLocalNotifications(context);

    ItemController.to.fetchItems();

    Future.delayed(const Duration(milliseconds: 1000), () {
      if (!_animationStarted) {
        _startImageAnimation();
      } else {
        _navigateToNextScreen();
      }
    });
  }

  void _startImageAnimation() {
    Future.delayed(const Duration(milliseconds: 700), () {
      setState(() {
        _imageOffset = -175.0;
        _animationStarted = true;
      });
    });

    Future.delayed(const Duration(milliseconds: 1000), () {
      _navigateToNextScreen();
    });
  }

  void _navigateToNextScreen() async {
    if (auth.currentUser != null) {
      if (auth.currentUser?.emailVerified ?? false) {
        await Get.find<UserController>().getUserData();
        Get.off(() => const Mainscreen());
      } else {
        Get.off(() => Emailverification(
              auth.currentUser?.email ?? "",
              returnToLastScreen: false,
            ));
      }
    } else {
      Get.off(() => const SignInPage());
    }
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    //   statusBarColor: Colors.transparent,
    //   statusBarIconBrightness: Brightness.light,
    // ));
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF00084B),
              Color(0xFF2E55C0),
              Color(0xFF148BFA),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  transform: Matrix4.translationValues(0, _imageOffset, 0),
                  child: SvgPicture.asset(
                    "assets/images/logo_white.svg",
                    width: 140,
                    height: 45,
                  ),
                ),
              ),
            ),
            const Expanded(
              child: Padding(
                padding: EdgeInsets.only(bottom: 60),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    "From DEVCOMM NSUT",
                    style: TextStyle(
                      color: Colors.white60,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
