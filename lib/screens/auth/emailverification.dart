import 'dart:async';
import 'package:amul/Utils/AppColors.dart';
import 'package:amul/controllers/user_controller.dart';
import 'package:amul/screens/auth/auth_snackbar.dart';
import 'package:amul/screens/auth/login_page.dart';
import 'package:amul/screens/mainscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class Emailverification extends StatefulWidget {
  final String email;
  final bool returnToLastScreen;

  const Emailverification(this.email,
      {this.returnToLastScreen = true, super.key});

  @override
  State<Emailverification> createState() => _EmailverificationState();
}

class _EmailverificationState extends State<Emailverification> {
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;

  late final appColors = Theme.of(context).extension<AppColors2>()!;

  @override
  void initState() {
    super.initState();
    autoredirect();
  }

  Future<void> resendlink() async {
    await auth.currentUser?.sendEmailVerification();
    showAuthSuccessSnackBar("", "Email sent successfully!");
  }

  Future<void> autoredirect() async {
    Timer.periodic(const Duration(seconds: 3), (timer) async {
      await auth.currentUser?.reload();
      if (auth.currentUser?.emailVerified ?? false) {
        timer.cancel();
        signIn();
      }
    });
  }

  Future<void> signIn() async {
    if (auth.currentUser?.emailVerified ?? false) {
      await Get.showOverlay(
          asyncFunction: () async {
            final userController = Get.find<UserController>();
            await userController.getUserData();
          },
          loadingWidget: const Center(
              child: CircularProgressIndicator(
            color: AppColors.blue,
          )));

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const Mainscreen()),
          (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(
            height: 100,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: SvgPicture.asset(
              "assets/images/logo.svg",
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Lottie.asset(
            "assets/raw/emailopen.json",
            height: 100,
            width: 100,
            repeat: false,
            frameRate: FrameRate(30),
          ),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: Text(
              "Verify your email address",
              style: TextStyle(
                fontSize: 18,
                color: appColors.primaryText,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Center(
            child: Text(
              widget.email,
              style: TextStyle(
                fontSize: 12,
                color: appColors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                "We have just send email verification link on \n your email Please check email and click on \n      that link to verify your Email address.",
                style: TextStyle(
                  color: appColors.primaryText,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                "If not auto redirected after verification , click \n                   on the Continue button.",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () {
              if (widget.returnToLastScreen) {
                Navigator.pop(context);
              } else {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const SignInPage()),
                    (route) => false);
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.arrow_back,
                  color: appColors.blue,
                ),
                Text(
                  "Change e-mail?",
                  style: TextStyle(
                    fontSize: 13,
                    color: appColors.blue,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
        child: Container(
          width: 140,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: appColors.blue, // Border color
              width: 1, // Border width
            ),
          ),
          child: InkWell(
            onTap: () => resendlink(),
            child: Center(
              child: Text(
                "Resend Link",
                style: TextStyle(
                    letterSpacing: 1.0,
                    color: appColors.onPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
              ),
            ),
          ),
        ),
      ),
      /*bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 140,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFF2546A9), // Border color
                  width: 1, // Border width
                ),
              ),
              child: InkWell(
                onTap: () => resendlink(),
                child: const Center(
                  child: Text(
                    "Resend Link",
                    style: TextStyle(
                        letterSpacing: 1.0,
                        color: Color(0xFF2546A9),
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                  ),
                ),
              ),
            ),
            */ /*InkWell(
              onTap: () {
                signIn(context, widget.email, widget.name, widget.id,



                    widget.password);
              },
              child: Container(
                width: 140,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: const Color(0xFF2546A9),
                  border: Border.all(
                    color: const Color(0xFF2546A9), // Border color
                    width: 1, // Border width
                  ),
                ),
                child: const Center(
                  child: InkWell(
                    child: Text(
                      "Confirm",
                      style: TextStyle(
                          letterSpacing: 1.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
                  ),
                ),
              ),
            ),*/ /*
          ],
        ),
      ),*/
    );
  }
}
