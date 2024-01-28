// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:amul/Utils/AppColors.dart';
import 'package:flutter/material.dart';

class About extends StatelessWidget {
  const About({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late final appColors = Theme.of(context).extension<AppColors2>()!;
    late final bool _isDarkMode =
        AdaptiveTheme.of(context).brightness == Brightness.dark ? true : false;

    return Scaffold(
        body: SingleChildScrollView(
            child: Column(children: [
      Container(
        height: 60,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xFF00084B),
              Color(0xFF2E55C0),
              Color(0xFF148BFA),
            ],
          ),
          /* borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(80),
                  bottomRight: Radius.circular(80),
                ),*/
        ),
      ),
      Container(
        height: 75,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xFF00084B),
              Color(0xFF2E55C0),
              Color(0xFF148BFA),
            ],
          ),
          /* borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(80),
                  bottomRight: Radius.circular(80),
                ),*/
        ),
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            Center(
              child: const Text(
                'About Us',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: 'Epilogue',
                  fontWeight: FontWeight.w700,
                  height: 0.06,
                ),
              ),
            ),
          ],
        ),
      ),
      Stack(children: [
        Container(
          height: 45,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xFF00084B),
                Color(0xFF2E55C0),
                Color(0xFF148BFA),
              ],
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.elliptical(40, 20),
              bottomRight: Radius.elliptical(40, 20),
            ),
          ),
        ),
        SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                SizedBox(
                  height: 80,
                ),
                Text(
                  'Amulx is an app made by the largest tech society of NSUT, Devcomm.',
                  style: TextStyle(
                      fontSize: 16,
                      color: appColors.text2,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Epilogue'),
                ),
              ],
            ),
          ),
        ),
      ])
    ])));
  }
}
