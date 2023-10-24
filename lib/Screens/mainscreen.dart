import 'package:flutter/material.dart';

import 'history.dart';
import 'home.dart';
import 'profile.dart';

class Mainscreen extends StatefulWidget {
  const Mainscreen({super.key});

  @override
  State<Mainscreen> createState() => _MainscreenState();
}

class _MainscreenState extends State<Mainscreen> {
  int myindex = 0;
  PageController _pageController = PageController(initialPage: 0);
  List<Widget> widgetList = const [
    HomePage(),
    History(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
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
            icon: Icon(Icons.history),
            label: 'History',
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
                duration: Duration(milliseconds: 50), curve: Curves.ease);
          });
        },
        selectedItemColor: const Color(0xFF2546A9),
      ),
    );
  }
}
