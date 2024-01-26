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
          'About Us',
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
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(30),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                'About DevComm',
                style: TextStyle(
                  color: appColors.text2,
                  fontSize: 18,
                  fontFamily: 'Epilogue',
                  fontWeight: FontWeight.w700,
                  height: 0.06,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Welcome to DevComm, where innovation meets community spirit at NSUT. We\'re the driving force behind apps like NSUT X, AmulX , connecting developers and fostering creativity in the digital realm. Join us in shaping the future together.',
                style: TextStyle(
                  color: appColors.text2,
                  fontSize: 14,
                  fontFamily: 'Epilogue',
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
