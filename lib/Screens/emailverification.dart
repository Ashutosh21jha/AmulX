import 'package:amul/Screens/mainscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

FirebaseAuth auth = FirebaseAuth.instance;

Future<void> authentication(String emailAddress, String password) async {
  try {
    final credential =
        await auth.createUserWithEmailAndPassword(
      email: emailAddress,
      password: password,
    );
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      print('The password provided is too weak.');
    } else if (e.code == 'email-already-in-use') {
      print('The account already exists for that email.');
    }
  } catch (e) {
    print(e);
  }
}

class Emailverification extends StatefulWidget {
  final String loginMail;
  final String loginpass;

  Emailverification(this.loginMail, this.loginpass);

  @override
  State<Emailverification> createState() => _EmailverificationState();
}

class _EmailverificationState extends State<Emailverification> {
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            InkWell(
              onTap: () {
                authentication(widget.loginMail, widget.loginpass);

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const Mainscreen()),
                  (route) => false,
                );
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
            ),
          ],
        ),
      ),
    );
  }
}
