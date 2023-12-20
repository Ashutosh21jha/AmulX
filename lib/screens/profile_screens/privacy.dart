// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';

class Privacy extends StatelessWidget {
  const Privacy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Privacy Policy',
          style: TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
            fontSize: 18,
            fontFamily: 'Epilogue',
            fontWeight: FontWeight.w700,
            height: 0.06,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          color: const Color.fromARGB(255, 0, 0, 0),
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
                  color: Color(0xFF282828),
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
                  color: Color(0xFF282828),
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
                'Welcome to MyWarkop! We are committed to protecting your privacy and ensuring that your personal information is handled with care. This Privacy Policy outlines how we collect, use, and safeguard your data when you use the MyWarkop app. By using the app, you consent to the practices described in this policy.',
                style: TextStyle(
                  color: Color(0xFF282828),
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
