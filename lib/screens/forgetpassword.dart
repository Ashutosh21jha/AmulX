import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:amul/Utils/AppColors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class forgetPassword extends StatefulWidget {
  const forgetPassword({super.key});

  @override
  State<forgetPassword> createState() => _forgetPasswordState();
}

class _forgetPasswordState extends State<forgetPassword> {
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
            'assets/images/devcommlogo.png',
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
            'assets/images/devcommlogo.png',
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
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              const Center(
                child: Text(
                  "Welcome to",
                  style: TextStyle(
                    color: Color(0xFF929497),
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Center(child: SvgPicture.asset("assets/images/logo.svg")),
              const SizedBox(height: 10),
              const Center(
                child: Text(
                  "   Before ordering, please login with your \n account",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF414042),
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Nsut e-mail",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: appColors.text2,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(right: 2, left: 2),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: _emailController,
                        validator: _validteEmail,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'e.g. Student@nsut.ac.in',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          fillColor: appColors.cardColor,
                          alignLabelWithHint: false,
                          filled: true,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2546A9),
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
                                    valueColor: AlwaysStoppedAnimation<Color>(
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
                    const SizedBox(height: 350),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/devcommlogo_noBG.png',
                    height: 50,
                    width: 50,
                  ),
                  Text(
                    "Powered by\nDevComm",
                    style: TextStyle(fontSize: 10),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
