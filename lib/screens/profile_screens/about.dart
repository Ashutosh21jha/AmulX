// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';

class About extends StatelessWidget {
  const About({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(
                children: [
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
                    child: Center(
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
                  ),
                  Stack(
                      children: [
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
                              bottomLeft: Radius.elliptical(40,20),
                              bottomRight: Radius.elliptical(40, 20),
                            ),
                          ),
                        ),
                        Align(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                SizedBox(height: 80,),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text('Amulx is an app made by the largest tech society of NSUT, Devcomm.',
                                    style: TextStyle(fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Epilogue'
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ]
                  )
                ]
            )
        )
    );
  }
}
