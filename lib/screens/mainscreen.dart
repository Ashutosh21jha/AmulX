import 'package:amul/Utils/AppColors.dart';
import 'package:amul/controllers/order_payment_controller.dart';
import 'package:amul/screens/profile.dart';
import 'package:amul/screens/cartPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'home/home_page.dart';

class Mainscreen extends StatefulWidget {
  const Mainscreen({super.key});

  @override
  State<Mainscreen> createState() => _MainscreenState();
}

class _MainscreenState extends State<Mainscreen> {
  @override
  void initState() {
    super.initState();

    Get.put(OrderPaymentController());
    // final userController = Get.find<UserController>();

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   Get.showOverlay(
    //       asyncFunction: userController.getUserData,
    //       loadingWidget: const Center(child: CircularProgressIndicator()));
    // });
  }

  int myindex = 0;
  final PageController _pageController = PageController(initialPage: 0);
  List<Widget> widgetList = [
    const HomePage(),
    const CartPage(fromFoodPage: false),
    const Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(
    //   const SystemUiOverlayStyle(
    //     statusBarColor: Colors.transparent,
    //     statusBarIconBrightness: Brightness.dark,
    //   ),
    // );
    return Scaffold(
      backgroundColor:
          Theme.of(context).extension<AppColors2>()!.backgroundColor,
      body: PageView(
        controller: _pageController,
        children: widgetList,
        onPageChanged: (index) {
          setState(() {
            myindex = index;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: myindex,
        onTap: (index) {
          setState(() {
            myindex = index;
            _pageController.animateToPage(index,
                duration: const Duration(milliseconds: 50), curve: Curves.ease);
          });
        },
        selectedItemColor: const Color(0xFF2546A9),
      ),
    );
  }
}
