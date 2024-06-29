import 'package:amul/screens/auth/auth_input_widget.dart';
import 'package:amul/screens/auth/auth_snackbar.dart';
import 'package:amul/screens/components/devcomm_logo.dart';
import 'package:amul/screens/auth/signup_page.dart';
import 'package:amul/widgets/amulX_appbar.dart';
import 'package:amul/widgets/custom_shape.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../Utils/AppColors.dart';
import 'emailverification.dart';
import 'forgetpassword.dart';
import '../mainscreen.dart';

enum SignInState {
  success,
  error,
  userNotFound,
  invalidCredential,
  tooManyRequests,
  needVerification
}

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  bool isLoading = false;
  bool passwordVisible = false;

  final _password = TextEditingController();
  final _emailController = TextEditingController();

  late final appColors = Theme.of(context).extension<AppColors2>()!;

  RegExp idRegex = RegExp(r'^\d{4}[A-Za-z]{3}\d{4}$');
  final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@nsut\.ac\.in$');

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _submitform() async {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text.toString();
      String password = _password.text.toString();

      final SignInState signInState = await signIn(
        email: email.toLowerCase(),
        context: context,
        password: password,
        isLoading: isLoading,
      );

      setState(() {
        isLoading = true;
      });

      switch (signInState) {
        case SignInState.success:
          Get.to(
            () => const Mainscreen(),
            preventDuplicates: true,
            duration: const Duration(milliseconds: 800),
            transition: Transition.rightToLeft,
          );
          break;
        case SignInState.needVerification:
          Get.to(
            () => Emailverification(email),
            preventDuplicates: true,
            duration: const Duration(milliseconds: 800),
            transition: Transition.rightToLeft,
          );
          break;
        case SignInState.userNotFound:
          showAuthErrorSnackBar("Error", "No user found for that email.");
          break;
        case SignInState.invalidCredential:
          showAuthErrorSnackBar("Error", "Wrong email or password.");
          break;
        case SignInState.tooManyRequests:
          showAuthErrorSnackBar("Error", "Too many requests. Try again later.");
          break;
        case SignInState.error:
          showAuthErrorSnackBar("Error", "Unknown Error");
          break;
        default:
          showAuthErrorSnackBar("Error", "Unknown Error");
      }

      setState(() {
        isLoading = false;
      });
    }
  }

  Future<SignInState> signIn(
      {required BuildContext context,
      required String email,
      required String password,
      required bool isLoading}) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);

      if (userCredential.user?.emailVerified ?? false) {
        return SignInState.success;
      }

      return SignInState.needVerification;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return SignInState.userNotFound;
      } else if (e.code == 'invalid-credential') {
        return SignInState.invalidCredential;
      } else if (e.code == 'too-many-requests') {
        return SignInState.tooManyRequests;
      } else {
        return SignInState.error;
      }
    }
  }

  void goToForgotPasswordPage() {
    Get.to(() => const ForgetPasswordPage(),
        duration: const Duration(
          milliseconds: 800,
        ),
        transition: Transition.rightToLeft);
  }

  String? _validteEmail(String? value) {
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
      backgroundColor: appColors.backgroundColor,
      body: SingleChildScrollView(
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  const AmulXAppBar(
                    title: "Sign In",
                  ),

                  // Stack(children: [
                  //   SvgPicture.asset('assets/images/shape.svg',
                  //       color: appColors.blue),
                  //   Container(
                  //     height: 10,
                  //     width: double.infinity,
                  //     color: appColors.blue,
                  //   ),
                  //   Positioned(
                  //       top: 100,
                  //       left: 20,
                  //       child: SvgPicture.asset(
                  //         'assets/images/logo.svg',
                  //         width: 48,
                  //         height: 48,
                  //         color: appColors.onPrimary,
                  //       )),
                  // ]),
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
                            icon: Icon(
                              Icons.email_rounded,
                              color: appColors.blue,
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: _validteEmail,
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
                                    color: appColors.blue,
                                  )),
                              obscureText: passwordVisible,
                              keyboardType: TextInputType.visiblePassword,
                              validator: _validatePassword,
                              controller: _password),
                          Align(
                            alignment: Alignment.topRight,
                            child: GestureDetector(
                              onTap: goToForgotPasswordPage,
                              child: Text(
                                "Forgot Password?",
                                style: TextStyle(
                                  shadows: [
                                    Shadow(
                                        color: appColors.blue,
                                        offset: const Offset(0, -5))
                                  ],
                                  color: Colors.transparent,
                                  decoration: TextDecoration.underline,
                                  decorationColor: appColors.blue,
                                  decorationThickness: 2,
                                  decorationStyle: TextDecorationStyle.solid,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: isLoading ? null : _submitform,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: appColors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(48),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: Center(
                                child: Text(
                                  "Sign In",
                                  style: TextStyle(
                                    color: appColors.onPrimary,
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
                                "Don't have an account?",
                                style: TextStyle(color: appColors.primaryText),
                              ),
                              TextButton(
                                  style: TextButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 0)),
                                  onPressed: () => Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => const SignUpPage()),
                                      (route) => false),
                                  child: Text(
                                    'Sign Up',
                                    style: TextStyle(color: appColors.blue),
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
