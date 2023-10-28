import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:amul/Screens/emailverification.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  bool passwordVisible = false;
  final _id = TextEditingController();
  final _emailController = TextEditingController();
  final _password = TextEditingController();

  // student id pattern
  RegExp pattern = RegExp(r'^\d{4}[A-Za-z]{3}\d{4}$');

  // email pattern
  final emailPattern = RegExp(r'^[a-zA-Z0-9._%+-]+@nsut\.ac\.in$');

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _submitform() {
    if (_formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              Emailverification(_emailController.text.toString()),
        ),
      );
    }
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
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 110,
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
              const SizedBox(height: 30),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      "Student ID",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Color(0xFF141414),
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
                          fillColor: Colors.white,
                          hintText: "e.g. 2022UME2022",
                          alignLabelWithHint: false,
                          filled: true,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Password",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Color(0xFF141414),
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
                          }
                          return null;
                        },
                        obscureText: passwordVisible,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          fillColor: Colors.white,
                          hintText: "Enter Your Password",
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
                    const SizedBox(height: 10),
                    const Text(
                      "Nsut e-mail",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Color(0xFF141414),
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
                          fillColor: Colors.white,
                          alignLabelWithHint: false,
                          filled: true,
                        ),
                      ),
                    ),
                    const SizedBox(height: 70),
                    ElevatedButton(
                      onPressed: _submitform,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2546A9),
                        // Set the background color here
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              48), // Set the border radius
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: Center(
                          child: Text(
                            "Login",
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
            ],
          ),
        ),
      ),
    );
  }
}
