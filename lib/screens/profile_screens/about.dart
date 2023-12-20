// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';

class About extends StatelessWidget {
  const About({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'About Us',
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
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(30),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                'About DevComm',
                style: TextStyle(
                  color: Color(0xFF282828),
                  fontSize: 18,
                  fontFamily: 'Epilogue',
                  fontWeight: FontWeight.w700,
                  height: 0.06,
                ),
              ),
              Text(
                'Welcome to DevComm, where innovation meets community spirit at NSUT. We\'re the driving force behind apps like NSUT X, AmulX , connecting developers and fostering creativity in the digital realm. Join us in shaping the future together.',
                style: TextStyle(
                  color: Color(0xFF282828),
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
