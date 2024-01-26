import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:amul/Utils/AppColors.dart';
import 'package:amul/screens/emailverification.dart';
import 'package:amul/screens/forgetpassword.dart';
import 'package:amul/screens/mainscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class signupPage extends StatefulWidget {
  const signupPage({super.key});

  @override
  State<signupPage> createState() => _signupPageState();
}

class _signupPageState extends State<signupPage> {
  final db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  bool isLoading = false;
  bool passwordVisible = false;
  final _id = TextEditingController();
  final _emailController = TextEditingController();
  final _password = TextEditingController();
  final _name = TextEditingController();
  late final appColors = Theme.of(context).extension<AppColors2>()!;
  late final bool _isDarkMode =
      AdaptiveTheme.of(context).brightness == Brightness.dark ? true : false;

  // student id pattern
  RegExp pattern = RegExp(r'^\d{4}[A-Za-z]{3}\d{4}$');

// email pattern
  final emailPattern = RegExp(r'^[a-zA-Z0-9._%+-]+@nsut\.ac\.in$');

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _submitform() async {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text.toString();
      String name = _name.text.toString();
      String rollno = _id.text.toString();
      String password = _password.text.toString();

      setState(() {
        isLoading = true;
      });

      try {
        await signUp(
          email: email.toLowerCase(),
          context: context,
          name: name,
          password: password,
          rollno: rollno,
          isLoading: isLoading,
        );
        setState(() {
          isLoading = false;
        });
      } catch (e) {
        print("Error during sign up: $e");
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> signUp(
      {required String email,
      required String password,
      required String rollno,
      required String name,
      required BuildContext context,
      required bool isLoading}) async {
    try {
      CollectionReference collection = db.collection('User');
      String documentId = email;

// Check if the document with the specified ID already exists
      var existingDocument = await collection.doc(documentId).get();

      if (existingDocument.exists) {
        Map<String, dynamic>? userData =
            existingDocument.data() as Map<String, dynamic>?;
        if (userData != null &&
                userData['name'].toString().toLowerCase() ==
                    name.toLowerCase() &&
                userData['student id'].toString().toLowerCase() ==
                    rollno
                        .toLowerCase() /*&&
          userData['password'] == password*/
            ) {
          signIn(
              context: context,
              email: email,
              password: password,
              isLoading: isLoading);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Invalid info"),
            ),
          );
        }
      } else {
        await auth.createUserWithEmailAndPassword(
            email: email, password: password);
        sendEmailVerification();
        isLoading = false;
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  Emailverification(email, name, rollno, password),
            ));
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw Exception('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        throw Exception('The account already exists for that email.');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> signIn(
      {required BuildContext context,
      required String email,
      required String password,
      required bool isLoading}) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      print(auth.currentUser?.email);
      isLoading = false;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Mainscreen()),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Wrong password"),
          ),
        );
      }
    }
  }

  Future<void> sendEmailVerification() async {
    await auth.currentUser?.sendEmailVerification();
    print("Verification email sent successfully");
  }

  String? _validteEmail(value) {
    if (value!.isEmpty) {
      return "can't be empty";
    }
    if (!emailPattern.hasMatch(value)) {
      return "Please enter a valid email";
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
              Center(
                child: Text(
                  "Welcome to",
                  style: TextStyle(
                    color: _isDarkMode ? Colors.white70 : Color(0xFF929497),
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Center(child: SvgPicture.asset("assets/images/logo.svg")),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  "   Before ordering, please login with your \n account",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _isDarkMode ? Colors.white60 : Color(0xFF414042),
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
                      "Name",
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
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "can't be empty";
                          }
                          return null;
                        },
                        controller: _name,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          fillColor: appColors.cardColor,
                          hintText: "e.g. userName",
                          alignLabelWithHint: false,
                          filled: true,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Student ID",
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
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "can't be empty";
                          }
                          if (!pattern.hasMatch(value)) {
                            return "Please enter a valid Id";
                          }
                          return null;
                        },
                        controller: _id,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          fillColor: appColors.cardColor,
                          hintText: "e.g. 2022UME2022",
                          alignLabelWithHint: false,
                          filled: true,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
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
                    const SizedBox(height: 10),
                    Text(
                      "Password",
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
                        controller: _password,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "can't be empty";
                          } else if (value.length < 6) {
                            return "Password should be at least 6 characters";
                          }
                          return null;
                        },
                        obscureText: passwordVisible,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          fillColor: appColors.cardColor,
                          hintText: "create new one or use exiting",
                          suffixIconColor: const Color(0xFF2546A9),
                          suffixIcon: InkWell(
                            onTap: () {
                              setState(
                                () {
                                  passwordVisible = !passwordVisible;
                                },
                              );
                            },
                            child: Icon(passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off),
                          ),
                          alignLabelWithHint: false,
                          filled: true,
                        ),
                        keyboardType: TextInputType.visiblePassword,
                        textInputAction: TextInputAction.done,
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () => isLoading ? null : _submitform(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2546A9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(48),
                        ),
                      ),
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
                                  "Sign In",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    InkWell(
                      onTap: () => Get.to(forgetPassword()),
                      child: Center(
                        child: Text(
                          "Forget Password?",
                          style: TextStyle(
                            color: appColors.text2,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
