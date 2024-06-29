import 'package:amul/Utils/AppColors.dart';
import 'package:amul/Utils/darkTheme.dart';
import 'package:amul/Utils/lightTheme.dart';
import 'package:amul/screens/auth/login_page.dart';
import 'package:amul/screens/components/devcomm_logo.dart';
import 'package:amul/screens/profile_screens/profile_card2.dart';
import 'package:amul/widgets/amulX_appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'profile_screens/about.dart';
import 'profile_screens/terms.dart';
import 'profile_screens/editprofile.dart';
import 'profile_screens/faq.dart';
import 'profile_screens/profile_card.dart';

final auth = FirebaseAuth.instance;
final db = FirebaseFirestore.instance;

String get userId => auth.currentUser?.email ?? '';

Future<void> signOut() async {
  try {
    print(auth.currentUser?.email);
    await auth.signOut();
  } catch (e) {
    throw Exception(e);
  }
}

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

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(
    //   const SystemUiOverlayStyle(
    //     statusBarColor: Colors.transparent,
    //     statusBarIconBrightness: Brightness.light,
    //   ),
    // );
    late AppColors2 appColors = Theme.of(context).extension<AppColors2>()!;
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            children: [
              const AmulXAppBar(
                title: '',
                showBackArrow: false,
              ),
              // Container(
              //   width: MediaQuery.of(context).size.width,
              //   alignment: Alignment.center,
              //   height: 140,
              //   decoration: const BoxDecoration(
              //     borderRadius: BorderRadius.only(
              //       bottomLeft: Radius.circular(30),
              //       bottomRight: Radius.circular(30),
              //     ),
              //     gradient: LinearGradient(
              //       begin: Alignment.centerLeft,
              //       end: Alignment.centerRight,
              //       colors: [
              //         Color(0xFF00084B),
              //         Color(0xFF2E55C0),
              //         Color(0xFF148BFA),
              //       ],
              //     ),
              //   ),
              //   child: const Text('My Profile',
              //       style: TextStyle(
              //         color: Colors.white,
              //         fontSize: 18,
              //         fontFamily: 'Epilogue',
              //         fontWeight: FontWeight.w700,
              //         height: 0.06,
              //       )),
              // ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 48, 0, 16),
                child: TextButton.icon(
                  onPressed: () async {
                    Get.changeTheme(
                        Get.isDarkMode ? lightThemeData() : darkThemeData());
                  },
                  label: Text(
                    Get.isDarkMode ? "Light Mode" : "Dark Mode",
                    style: TextStyle(color: appColors.primaryText),
                  ),
                  icon: Icon(
                    Get.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                    color: appColors.primaryText,
                  ),
                ),
              ),
              ProfileCard(
                  icon: Icons.person,
                  text: "Profile",
                  implement: false,
                  textColor: appColors.onPrimary,
                  top: true,
                  screen: const EditProfile(),
                  iconColor: const Color(0xFFA287F8)),
              ProfileCard(
                  icon: Icons.info_outline,
                  text: "About Us",
                  implement: false,
                  textColor: appColors.onPrimary,
                  screen: const About(),
                  iconColor: const Color(0xFF02B9F0)),
              ProfileCard(
                  icon: Icons.question_answer_outlined,
                  text: "FAQ",
                  implement: false,
                  textColor: appColors.onPrimary,
                  screen: Faq(),
                  iconColor: const Color(0xFFFC6DBB)),
              ProfileCard(
                  icon: Icons.file_copy,
                  implement: false,
                  text: "Terms and Conditions",
                  textColor: appColors.onPrimary,
                  screen: const Terms(),
                  iconColor: const Color(0xFF3BA889)),
              const ProfileCard(
                icon: Icons.logout,
                implement: true,
                text: "Logout",
                bottom: true,
                screen: SignInPage(),
                iconColor: Color(0xFFF57878),
                textColor: Color(0xFFF46363),
              ),
            ],
          ),
          Positioned(top: 100, child: ProfileCard2()),
          const DevcommLogo()
        ],
      ),
    );
  }
}
