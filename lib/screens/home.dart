import 'package:amul/controllers/items_controller.dart';
import 'package:amul/screens/cart_components/cart_controller.dart';
import 'package:amul/screens/history.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'foodPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomeState();
}

class _HomeState extends State<HomePage> {
  final db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    CartController.to.fetchCart();
  /*  CartController.to.reloadFetchData();*/
    CartController.to.fetchCurrentOrder();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),

            // logo and avatar container
            Padding(
              padding: const EdgeInsets.only(
                  left: 24, right: 30, top: 10, bottom: 10),
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
                      GestureDetector(
                        onTap: () => Get.to(History()),
                        child: const Icon(
                          Icons.history,
                          size: 30,
                        ),
                      )

                      /*const CircleAvatar(
                        backgroundImage: AssetImage("assets/images/avatar.png"),
                        backgroundColor: Colors.transparent,
                        radius: 22,
                      ),*/
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
                letterSpacing: 0.02 * 16,
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
                          Get.to(FoodPage(
                            cat: "Food",
                            itemList: ItemController.to.food,
                          ));
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
                          Get.to(FoodPage(
                            cat: "Drinks",
                            itemList: ItemController.to.drink,
                          ));
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
                          Get.to(FoodPage(
                            cat: "Munchies",
                            itemList: ItemController.to.munchies,
                          ));
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
                          Get.to(FoodPage(
                            cat: "Dairy",
                            itemList: ItemController.to.dairy,
                          ));
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
      ),
      // bottomNavigationBar: BottomNav(),
    );
  }
}
