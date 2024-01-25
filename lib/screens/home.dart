import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:amul/Utils/AppColors.dart';
import 'package:amul/controllers/items_controller.dart';
import 'package:amul/screens/cart_components/cart_controller.dart';
import 'package:amul/screens/history.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'foodPage.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomeState();
}

class _HomeState extends State<HomePage> {
  final db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  late final AppColors2 appColors = Theme.of(context).extension<AppColors2>()!;
  late final bool _isDarkTheme =
      AdaptiveTheme.of(context).brightness == Brightness.dark ? true : false;

  @override
  void initState() {
    super.initState();
    CartController.to.fetchCart();
    CartController.to.fetchCurrentOrder();
  }

  Widget closedStoreMessage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          height: 40,
        ),
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
                  GestureDetector(
                    onTap: () => Get.to(History()),
                    child: const Icon(
                      Icons.history,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: const Text(
              'Store is Closed',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.red,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget openStoreContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 40,
          ),
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
                    GestureDetector(
                      onTap: () => Get.to(History()),
                      child: const Icon(
                        Icons.history,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 45),
          Text(
            "Answer your\nappetite!",
            style: TextStyle(
              color: _isDarkTheme ? Colors.white60 : Color(0xFF414042),
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
                          color:
                              _isDarkTheme ? AppColors.blackbase : Colors.white,
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
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 6.5,
                  ),
                  Text(
                    "Food",
                    style: TextStyle(
                      color: appColors.text1,
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
                          color:
                              _isDarkTheme ? AppColors.blackbase : Colors.white,
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
                            "assets/images/drinks.png",
                            fit: BoxFit.contain,
                            width: 70,
                            height: 73,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 6.5,
                  ),
                  Text(
                    "Drinks",
                    style: TextStyle(
                      color: appColors.text1,
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
                          color:
                              _isDarkTheme ? AppColors.blackbase : Colors.white,
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
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 6.5,
                  ),
                  Text(
                    "Munchies",
                    style: TextStyle(
                      // color: Color(0xFF57585B),
                      color: appColors.text1,
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
                          color:
                              _isDarkTheme ? AppColors.blackbase : Colors.white,
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
                            "assets/images/dairy.png",
                            fit: BoxFit.contain,
                            width: 62,
                            height: 62,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 6.5,
                  ),
                  Text(
                    "Dairy",
                    style: TextStyle(
                      color: appColors.text1,
                      fontSize: 14,
                    ),
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: db.collection('menu').doc('today menu').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final sessionData = snapshot.data;
        final bool isStoreOpen = sessionData?['session'] ?? false;

        return Scaffold(
          body: isStoreOpen ? openStoreContent() : closedStoreMessage(),
        );
      },
    );
  }
}
