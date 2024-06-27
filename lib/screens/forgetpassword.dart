import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:amul/Utils/AppColors.dart';
import 'package:amul/screens/auth/auth_input_widget.dart';
import 'package:amul/screens/components/devcomm_logo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _forgetPasswordState();
}

class _forgetPasswordState extends State<ForgetPasswordPage> {
  final db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  final _emailController = TextEditingController();
  bool isLoading = false;
  late final appColors = Theme.of(context).extension<AppColors2>()!;
  late final bool _isDarkMode =
      AdaptiveTheme.of(context).brightness == Brightness.dark ? true : false;

  final emailPattern = RegExp(r'^[a-zA-Z0-9._%+-]+@nsut\.ac\.in$');
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _validteEmail(value) {
    if (value!.isEmpty) {
      return "can't be empty";
    }
    if (!emailPattern.hasMatch(value)) {
      return "Please enter a valid email";
    }
    return null;
  }

  Future<void> resentpassword() async {
    String email = _emailController.text.toString();

    try {
      CollectionReference collection = db.collection('User');
      String documentId = email;
      var existingDocument = await collection.doc(documentId).get();

      if (existingDocument.exists) {
        await auth.sendPasswordResetEmail(email: email);
        Get.snackbar(
          'Password Reset link Sent!',
          'Thank You for using Amul',
          backgroundGradient: const LinearGradient(
            colors: [
              Color(0xFF00084B),
              Color(0xFF2E55C0),
              Color(0xFF148BFA),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          duration: const Duration(seconds: 2),
          barBlur: 10,
          icon: Image.asset(
            'assets/images/icon.png',
            width: 24,
            height: 24,
          ),
        );
      } else {
        Get.snackbar(
          'You do not have account yet!',
          'Sign Up using Nsut credentials',
          backgroundGradient: const LinearGradient(
            colors: [
              Color(0xFF00084B),
              Color(0xFF2E55C0),
              Color(0xFF148BFA),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          duration: const Duration(seconds: 2),
          barBlur: 10,
          icon: Image.asset(
            'assets/images/icon.png',
            width: 24,
            height: 24,
          ),
        );
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> _submitform() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      resentpassword();
      setState(() {
        isLoading = false;
      });
    }
    Get.back();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.blue,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: appColors.scaffoldBackgroundColor,
          ),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Stack(children: [
                    SvgPicture.asset('assets/images/shape.svg',
                        color: AppColors.blue),
                    Container(
                      height: 10,
                      width: double.infinity,
                      color: AppColors.blue,
                    ),
                    Positioned(
                        top: 100,
                        left: 20,
                        child: SvgPicture.asset(
                          'assets/images/logo.svg',
                          width: 48,
                          height: 48,
                          color: appColors.scaffoldBackgroundColor,
                        )),
                  ]),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          AuthInputWidget(
                            hintText: "e.g, student@nsut.ac.in",
                            label: "Email",
                            icon: const Icon(
                              Icons.email,
                              color: AppColors.blue,
                            ),
                            controller: _emailController,
                            validator: _validteEmail,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    48), // Set the border radius
                              ),
                            ),
                            onPressed: () => isLoading ? null : _submitform(),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: Center(
                                child: isLoading
                                    ? const SizedBox(
                                        height: 15,
                                        width: 15,
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.white),
                                        ),
                                      )
                                    : const Text(
                                        "Reset Password",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const DevcommLogo()
          ],
        ),
      ),
    );
  }
}
