import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:amul/screens/auth/auth_input_widget.dart';
import 'package:amul/screens/auth/auth_snackbar.dart';
import 'package:amul/screens/components/devcomm_logo.dart';
import 'package:amul/screens/auth/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../Utils/AppColors.dart';
import 'emailverification.dart';
import '../mainscreen.dart';

enum SignUpState { alreadyRegistered, success, error, weakPassword }

class SignUpPage extends StatefulWidget {
  const SignUpPage({
    super.key,
  });

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  bool isLoading = false;
  bool passwordVisible = false;
  final _idController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  late final appColors = Theme.of(context).extension<AppColors2>()!;
  late final bool _isDarkMode =
      AdaptiveTheme.of(context).brightness == Brightness.dark ? true : false;

  RegExp idRegex = RegExp(r'^\d{4}[A-Za-z]{3}\d{4}$');
  final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@nsut\.ac\.in$');

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _submitform() async {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text.toString();
      String name = _nameController.text.toString();
      String id = _idController.text.toString();
      String password = _passwordController.text.toString();

      setState(() {
        isLoading = true;
      });

      final signUpState = await signUp(
        email: email.toLowerCase(),
        context: context,
        name: name,
        password: password,
        id: id,
        isLoading: isLoading,
      );

      switch (signUpState) {
        case SignUpState.alreadyRegistered:
          showAuthErrorSnackBar(
              "Error", "Email already registered. Please sign in.");
          break;
        case SignUpState.success:
          Get.to(
            () => Emailverification(
              email,
            ),
            preventDuplicates: true,
            duration: const Duration(milliseconds: 800),
            transition: Transition.rightToLeft,
          );
          break;
        case SignUpState.error:
          showAuthErrorSnackBar(
              "Error", "An error occurred. Please try again.");
          break;
        default:
          showAuthErrorSnackBar(
              "Error", "An error occurred. Please try again.");
          break;
      }

      setState(() {
        isLoading = false;
      });
    }
  }

  // Future<bool> addUserToFirestore(
  //     String email, String name, String id, String uid) async {
  //   try {
  //     await db.collection('User').doc(email).set({
  //       "name": name,
  //       "student id": id,
  //       "userUid": uid,
  //       "currentOrder": null,
  //       "verified": false
  //     });
  //   } on FirebaseException catch (e) {
  //     return false;
  //   }
  //   return true;
  // }

  Future<bool> addUserToFirestore(
      String email, String name, String id, String uid) async {
    try {
      db.collection('User').doc(email).set({
        "name": name,
        "student id": id,
        "userUid": uid,
        "currentOrder": null,
      });
    } on FirebaseException catch (e) {
      return false;
    }

    return true;
  }

  Future<SignUpState> signUp(
      {required String email,
      required String password,
      required String id,
      required String name,
      required BuildContext context,
      required bool isLoading}) async {
    try {
      final UserCredential userCredential = await auth
          .createUserWithEmailAndPassword(email: email, password: password);

      final userSuccessfullyAddedToFirestore =
          await addUserToFirestore(email, name, id, userCredential.user!.uid);

      if (!userSuccessfullyAddedToFirestore) {
        await userCredential.user?.delete();
      }

      sendEmailVerification();

      return SignUpState.success;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return SignUpState.weakPassword;
      } else if (e.code == 'email-already-in-use') {
        return SignUpState.alreadyRegistered;
      } else {
        return SignUpState.error;
      }
    }

    // try {
    //   CollectionReference collection = db.collection('User');
    //   String documentId = email;

    //   final existingDocument = await collection.doc(documentId).get();

    //   if (existingDocument.exists) {
    //     Map<String, dynamic>? userData =
    //         existingDocument.data() as Map<String, dynamic>?;

    //     if (userData == null || userData['verified'] == false) {
    //       return SignUpState.needVerification;
    //     } else {
    //       return SignUpState.alreadyRegistered;
    //     }
    //   } else {
    //     final UserCredential userCredential = await auth
    //         .createUserWithEmailAndPassword(email: email, password: password);
    //   }

    //   return SignUpState.success;
    // } on FirebaseAuthException catch (e) {
    //   return SignUpState.error;
    //   // if (e.code == 'weak-password') {
    //   //   throw Exception('The password provided is too weak.');
    //   // } else if (e.code == 'email-already-in-use') {
    //   //   throw Exception('The account already exists for that email.');
    //   // }
    // } catch (e) {
    //   return SignUpState.error;
    // }
  }

  Future<void> sendEmailVerification() async {
    await auth.currentUser?.sendEmailVerification();
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty || value.length < 3) {
      return "Please enter valid name";
    }

    return null;
  }

  String? _validateId(String? value) {
    if (value == null || value.isEmpty || !idRegex.hasMatch(value)) {
      return "Please enter a valid student ID";
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty || !emailRegex.hasMatch(value)) {
      return "Please enter a valid email";
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty || value.length < 6) {
      return "Password should be at least 6 characters";
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    passwordVisible = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
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
                            hintText: "Name",
                            label: "Name",
                            icon: const Icon(
                              Icons.person_rounded,
                              color: AppColors.blue,
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: _validateName,
                            controller: _nameController,
                            obscureText: false,
                          ),
                          AuthInputWidget(
                            hintText: "e.g, 2023UIT3033",
                            label: "Student ID",
                            icon: const Icon(
                              Icons.school_rounded,
                              color: AppColors.blue,
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: _validateId,
                            controller: _idController,
                            obscureText: false,
                          ),
                          AuthInputWidget(
                            hintText: "e.g, student@nsut.ac.in",
                            label: "Email",
                            icon: const Icon(
                              Icons.email_rounded,
                              color: AppColors.blue,
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: _validateEmail,
                            controller: _emailController,
                            obscureText: false,
                          ),
                          AuthInputWidget(
                              hintText: "*************",
                              label: "Password",
                              icon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      passwordVisible = !passwordVisible;
                                    });
                                  },
                                  icon: Icon(
                                    passwordVisible
                                        ? Icons.visibility_off_rounded
                                        : Icons.visibility_rounded,
                                    color: AppColors.blue,
                                  )),
                              obscureText: passwordVisible,
                              keyboardType: TextInputType.visiblePassword,
                              validator: _validatePassword,
                              controller: _passwordController),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: isLoading ? null : _submitform,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(48),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: Center(
                                child: Text(
                                  "Sign Up",
                                  style: TextStyle(
                                    color: appColors.whiteText,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Already have an account?",
                                style: TextStyle(color: appColors.text2),
                              ),
                              TextButton(
                                  style: TextButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 0)),
                                  onPressed: () => Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => const SignInPage()),
                                      (route) => false),
                                  child: const Text(
                                    'Sign In',
                                    style: TextStyle(color: AppColors.blue),
                                  ))
                            ],
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
