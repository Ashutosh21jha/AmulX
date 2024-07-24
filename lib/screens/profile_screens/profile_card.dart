import 'package:amul/screens/auth/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';

const EdgeInsets _paddingButtons =
    EdgeInsets.symmetric(horizontal: 12, vertical: 8);

const List<BoxShadow> _shadows = [
  BoxShadow(
    color: Color(0x28606170),
    blurRadius: 4,
    offset: Offset(0, 2),
    spreadRadius: 0,
  ),
  BoxShadow(
    color: Color(0x0A28293D),
    blurRadius: 1,
    offset: Offset(0, 0),
    spreadRadius: 0,
  )
];

final auth = FirebaseAuth.instance;
final db = FirebaseFirestore.instance;

Future<void> signOut() async {
  try {
    await auth.signOut();
    Get.offAll(
      () => const SignInPage(),
    );
  } catch (e) {
    // Todo : handle
    throw Exception(e);
  }
}

class ProfileCard extends StatelessWidget {
  final String text;
  final IconData icon;
  final Widget screen;
  final bool implement;
  final Color iconColor;
  final Color textColor;
  final bool top;
  final bool bottom;

  const ProfileCard({
    Key? key,
    required this.text,
    required this.icon,
    required this.screen,
    required this.implement,
    required this.iconColor,
    this.textColor = Colors.white,
    this.top = false,
    this.bottom = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late final BorderRadius borderRadius;

    if (top) {
      borderRadius = const BorderRadius.only(
          topRight: Radius.circular(12), topLeft: Radius.circular(12));
    } else if (bottom) {
      borderRadius = const BorderRadius.only(
          bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12));
    } else {
      borderRadius = BorderRadius.circular(0);
    }

    return InkWell(
      onTap: () async {
        if (implement == true) {
          await signOut();
        } else {
          Get.to(
            () => screen,
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        child: Card(
          clipBehavior: Clip.hardEdge,
          margin: const EdgeInsets.symmetric(vertical: 1),
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
          elevation: 0.5,
          // color: Colors.blueGrey.shade100,
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                const Color(0xFF00084B).withAlpha(240),
                const Color(0xFF2E55C0).withAlpha(240),
                const Color(0xFF148BFA).withAlpha(240),
              ],
            )),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(4),
                decoration: ShapeDecoration(
                  color: iconColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: Container(
                  width: 24,
                  height: 24,
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              title: Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontSize: 16,
                  fontFamily: 'Epilogue',
                  fontWeight: FontWeight.w400,
                  height: 0.08,
                ),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios_sharp,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
