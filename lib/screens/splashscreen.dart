import 'dart:async';
import 'package:amul/screens/mainscreen.dart';
import 'package:amul/screens/signupPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

final auth = FirebaseAuth.instance;

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key});

  @override
  _Splashscreenstate createState() => _Splashscreenstate();
}

class _Splashscreenstate extends State<SplashScreen> {
  double _imageOffset = 0.0;
  bool _animationStarted = false;

  @override
  void initState() {
    super.initState();

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

  void _navigateToNextScreen() {
    if (auth.currentUser != null) {
      print(auth.currentUser?.uid);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Mainscreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const signupPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF00084B),
              Color(0xFF2E55C0),
              Color(0xFF148BFA),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
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
                  // Translate the image upward
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
                // Add padding to the bottom
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
