// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:amul/Utils/AppColors.dart';
import 'package:flutter/material.dart';

class Terms extends StatelessWidget {
  const Terms({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late final appColors = Theme.of(context).extension<AppColors2>()!;
    late final bool _isDarkMode =
        AdaptiveTheme.of(context).brightness == Brightness.dark ? true : false;

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFF00084B),
            Color(0xFF2E55C0),
            Color(0xFF148BFA),
          ],
        ))),
        title: Text(
          'Terms and Conditions',
          style: TextStyle(
            color: appColors.whiteText,
            fontSize: 18,
            fontFamily: 'Epilogue',
            fontWeight: FontWeight.w700,
            height: 0.06,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          color: appColors.whiteText,
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 30,
              left: 30,
              right: 30,
              child: Text(
                'DevComm Privacy Policy',
                style: TextStyle(
                  color: appColors.text2,
                  fontSize: 18,
                  fontFamily: 'Epilogue',
                  fontWeight: FontWeight.w700,
                  height: 0.06,
                ),
              ),
            ),
            Positioned(
              top: 60,
              left: 30,
              right: 30,
              child: Text(
                'Last Update: 15 July 2023',
                style: TextStyle(
                  color: appColors.text2,
                  fontSize: 14,
                  fontFamily: 'Epilogue',
                  fontWeight: FontWeight.w500,
                  height: 0.07,
                ),
              ),
            ),
            Positioned(
              top: 80,
              left: 30,
              right: 30,
              child: Text(
                'Welcome to MyWarkop! Before you start using our app, please take a moment to read and understand the following terms and conditions. By using the MyWarkop app, you agree to comply with these terms, and your use of the app is subject to the following conditions:',
                style: TextStyle(
                  color: appColors.text2,
                  fontSize: 14,
                  fontFamily: 'Epilogue',
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
