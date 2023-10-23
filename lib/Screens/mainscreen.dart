import 'package:amul/Screens/home.dart';
import 'package:amul/Screens/profile.dart';
import 'package:flutter/material.dart';

import 'history.dart';
class Mainscreen extends StatefulWidget {
  const Mainscreen({super.key});

  @override
  State<Mainscreen> createState() => _MainscreenState();
}

class _MainscreenState extends State<Mainscreen> {
  int myindex = 0;
  List<Widget> widgetList = const[
   HomePage(),
    History(),
    Profile(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: myindex,
        children: widgetList,
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
          });
        },
        selectedItemColor: const Color(0xFF2546A9),
      ),
    );
  }
}
