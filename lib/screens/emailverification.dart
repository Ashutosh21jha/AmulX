import 'dart:async';
import 'package:amul/screens/mainscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';

final auth = FirebaseAuth.instance;
final db = FirebaseFirestore.instance;
late Timer _timer;

Future<void> resendlink() async {
  await auth.currentUser?.sendEmailVerification();
  print("re-Verification email sent successfully");
}

Future<void> signIn(BuildContext context, String email, String name,
    String s_id, String password) async {
  if (auth.currentUser?.emailVerified ?? false) {
    auth.createUserWithEmailAndPassword(email: email, password: password);
    String? userUid = auth.currentUser?.uid;
    print(auth.currentUser?.email);

    await db.collection('User').doc(email).set({
      "name": name,
      "student id": s_id,
      "userUid": userUid,
      "currentOrder": null,
    }).catchError((error) {
      print("Error adding data: $error");
    });
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Mainscreen()),
        (route) => false);
  }
}

Future<void> deleteUserAfterDelay() async {
  await Future.delayed(Duration(seconds: 180));

  try {
    if (auth.currentUser?.emailVerified == false ||
        auth.currentUser?.emailVerified == null) {
      // Delete the user
      await auth.currentUser?.delete();
      print("User deleted successfully.");
      await auth.signOut();
    } else {
      print("User is verified. No deletion needed.");
    }
  } catch (e) {
    print("Error deleting user: $e");
  }
}

Future<void> autoredirect(BuildContext context, String loginMail, String name,
    String s_id, String password) async {
  _timer = Timer.periodic(Duration(seconds: 3), (timer) {
    auth.currentUser?.reload();
    if (auth.currentUser?.emailVerified ?? false) {
      timer.cancel();
      signIn(context, loginMail, name, s_id, password);
    } else {
      print("email is not verified yet!");
    }
  });
}

class Emailverification extends StatefulWidget {
  final String loginMail, name, s_id, password;

  Emailverification(this.loginMail, this.name, this.s_id, this.password);

  @override
  State<Emailverification> createState() => _EmailverificationState();
}

class _EmailverificationState extends State<Emailverification> {
  @override
  void initState() {
    super.initState();
    autoredirect(
        context, widget.loginMail, widget.name, widget.s_id, widget.password);
    deleteUserAfterDelay();
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
          const Center(
            child: Text(
              "Verify your email address",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Center(
            child: Text(
              widget.loginMail,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF2546A9),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                "We have just send email verification link on \n your email Please check email and click on \n      that link to verify your Email address.",
                style: TextStyle(
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
              Navigator.pop(context);
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.arrow_back,
                  color: Color(0xFF2546A9),
                ),
                Text(
                  "Change e-mail?",
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF2546A9),
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
            *//*InkWell(
              onTap: () {
                signIn(context, widget.loginMail, widget.name, widget.s_id,
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
            ),*//*
          ],
        ),
      ),*/
    );
  }
}
