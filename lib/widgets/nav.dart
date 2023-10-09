import 'package:flutter/material.dart';
import '../screens/home.dart';
import '../screens/history.dart';

final Map<String, Widget> _widgetOptions = {
  'home': Home(),
  'history': History(),
  'profile': Text(
    'Profile',
    style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
  ),
};

void _onItemTapped(int index) {
  // Add your logic here
  // For example:
  // if (index == 0) {
  //   Navigator.pushNamed(context, '/home');
  // } else if (index == 1) {
  //   Navigator.pushNamed(context, '/profile');
  // } else if (index == 2) {
  //   Navigator.pushNamed(context, '/settings');
  // }
}

final bottomNavigationBar = BottomNavigationBar(
  items: const <BottomNavigationBarItem>[
    // Add your navigation items here
    // For example:
    // BottomNavigationBarItem(
    //   icon: Icon(Icons.home),
    //   label: 'Home',
    // ),
    // BottomNavigationBarItem(
    //   icon: Icon(Icons.person),
    //   label: 'Profile',
    // ),
    // BottomNavigationBarItem(
    //   icon: Icon(Icons.settings),
    //   label: 'Settings',
    // ),
  ],
  currentIndex: 0,
  selectedItemColor: Colors.amber[800],
  onTap: _onItemTapped,
);
