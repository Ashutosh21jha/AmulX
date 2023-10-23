import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../components/bottom_nav.dart';
import 'history.dart';
import 'profile.dart';
import 'foodPage.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 40,
          ),

          // logo and avatar container
          Padding(
            padding:
                const EdgeInsets.only(left: 24, right: 30, top: 10, bottom: 10),
            child: SizedBox(
              height: 92,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SvgPicture.asset(
                      "assets/images/logo.svg",
                      width: 85,
                      height: 30,
                    ),
                    Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage(
                            "assets/images/avatar.png",
                          ),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 45),

          const Text(
            "Answer your\nappetite!",
            style: TextStyle(
              color: Color(0xFF414042),
              fontSize: 26,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.02 *
                  16, // 2% of the font size (16 logical pixels in this case)
              // Line height (32 / 16 = 2.0)
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),

          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            children: [
              // food item container
              Column(
                children: [
                  Center(
                    child: InkWell(
                      onTap: () {
                        Get.to(FoodPage());
                      },
                      child: Container(
                          width: 134.5,
                          height: 134.5,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                spreadRadius: 1,
                                blurRadius: 1,
                              ),
                            ],
                          ),
                          child: Center(
                              child: Image.asset(
                            "assets/images/food.png",
                            fit: BoxFit.contain,
                            width: 80,
                            height: 83,
                          ))),
                    ),
                  ),
                  const SizedBox(
                    height: 6.5,
                  ),
                  const Text(
                    "Food",
                    style: TextStyle(
                      color: Color(0xFF57585B),
                      fontSize: 14,
                    ),
                  )
                ],
              ),

              //Drinks items container
              Column(
                children: [
                  Center(
                    child: InkWell(
                      onTap: () {
                        Get.to(FoodPage());
                      },
                      child: Container(
                        width: 134.5,
                        height: 134.5,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              spreadRadius: 1,
                              blurRadius: 1,
                            ),
                          ],
                        ),
/*
                        child: Center(child: SvgPicture.asset( "assets/images/df.svg",fit: BoxFit.contain,width: 44,height: 57,)),
*/
                        child: Center(
                            child: Image.asset(
                          "assets/images/drinks.png",
                          fit: BoxFit.contain,
                          width: 70,
                          height: 73,
                        )),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 6.5,
                  ),
                  const Text(
                    "Drinks",
                    style: TextStyle(
                      color: Color(0xFF57585B),
                      fontSize: 14,
                    ),
                  )
                ],
              ),

              //munchies items container
              Column(
                children: [
                  Center(
                    child: InkWell(
                      onTap: () {
                        Get.to(FoodPage());
                      },
                      child: Container(
                        width: 134.5,
                        height: 134.5,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              spreadRadius: 1,
                              blurRadius: 1,
                            ),
                          ],
                        ),
                        child: Center(
                            child: Image.asset(
                          "assets/images/munchies.png",
                          fit: BoxFit.contain,
                          width: 66,
                          height: 70,
                        )),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 6.5,
                  ),
                  const Text(
                    "Munchies",
                    style: TextStyle(
                      color: Color(0xFF57585B),
                      fontSize: 14,
                    ),
                  )
                ],
              ),

              // diary items container
              Column(
                children: [
                  Center(
                    child: InkWell(
                      onTap: () {
                        Get.to(FoodPage());
                      },
                      child: Container(
                        width: 134.5,
                        height: 134.5,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              spreadRadius: 1,
                              blurRadius: 1,
                            ),
                          ],
                        ),
/*
                        child: Center(child: SvgPicture.asset( "assets/images/df.svg",fit: BoxFit.contain,width: 44,height: 57,)),
*/
                        child: Center(
                            child: Image.asset(
                          "assets/images/dairy.png",
                          fit: BoxFit.contain,
                          width: 62,
                          height: 62,
                        )),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 6.5,
                  ),
                  const Text(
                    "Dairy",
                    style: TextStyle(
                      color: Color(0xFF57585B),
                      fontSize: 14,
                    ),
                  )
                ],
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomNav(),
    );
  }
}
