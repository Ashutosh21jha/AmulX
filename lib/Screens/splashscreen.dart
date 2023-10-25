import 'dart:async';
import 'package:amul/Screens/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _imageOffset = 0.0;
  bool _animationStarted = false;

  @override
  void initState() {
    super.initState();

    // After 3000 milliseconds (3 seconds), navigate to the next screen
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (!_animationStarted) {
        _startImageAnimation();
      } else {
        _navigateToNextScreen();
      }
    });
  }

  // Function to start the image animation
  void _startImageAnimation() {
    // After 500 milliseconds (0.5 seconds), start the animation
    Future.delayed(const Duration(milliseconds: 700), () {
      setState(() {
        _imageOffset = -175.0; // Move the image up by 200 pixels
        _animationStarted = true;
      });
    });

    // After 2500 milliseconds (2.5 seconds), navigate to the next screen
    Future.delayed(const Duration(milliseconds: 1000), () {
      _navigateToNextScreen();
    });
  }

  // Function to navigate to the next screen
  void _navigateToNextScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Loginpage()),
    );
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
                padding: EdgeInsets.only(bottom: 60), // Add padding to the bottom
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
