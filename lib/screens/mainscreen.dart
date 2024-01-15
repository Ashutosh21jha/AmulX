import 'package:amul/screens/profile.dart';
import 'package:amul/screens/cartPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home.dart';


class Mainscreen extends StatefulWidget {
  const Mainscreen({super.key});

  @override
  State<Mainscreen> createState() => _MainscreenState();
}

class _MainscreenState extends State<Mainscreen> {
  int myindex = 0;
  final PageController _pageController = PageController(initialPage: 0);
  List<Widget> widgetList =  [
    const HomePage(),
    CartPage(false),
    const Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    return Scaffold(
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
