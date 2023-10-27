import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:amul/Screens/emailverification.dart';
import 'home.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  bool passwordVisible = false;
  bool _showErrorText = false;
  final _text1 = TextEditingController();
  final _emailController = TextEditingController();
  final _text2 = TextEditingController();
  bool _validate = false;
  TextEditingController textController1 = TextEditingController();
  TextEditingController textController2 = TextEditingController();
  TextEditingController textController3 = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      _showErrorText = true;
    });
    passwordVisible = true;
    textController1.text = "can't be empty";
    textController2.text = "can't be empty";
    textController3.text = "can't be empty";
  }

  // @override
  // void dispose() {
  //   _text1.dispose();
  //   _text2.dispose();
  //
  //   super.dispose();
  // }

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
                height: 130,
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
              const SizedBox(height: 50),
              const Text(
                "Student ID",
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Color(0xFF141414),
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 10),

              Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xFFD1D2D3), // Border color
                    width: 1, // Border width
                  ),
                  borderRadius: BorderRadius.circular(8.0), // Border radius
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 5, left: 5),
                    child: TextFormField(
                      controller: _text1,
                      decoration: const InputDecoration(
                        /*errorText: _validate ? 'Input Valid Info' : null,*/
                        border: InputBorder.none,
                        fillColor: Colors.white,
                        hintText: "Enter Your Student ID",
                        alignLabelWithHint: false,
                        filled: true,
                      ),
                    ),
                  ),
                ),
              ),

              Visibility(
                visible: !_showErrorText,
                // Set visibility based on the condition
                child: const Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "can't be empty",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),

              Visibility(
                  visible: _showErrorText,
                  child: const SizedBox(
                    height: 10,
                  )),

              // Password TextField

              const Text(
                "Password",
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Color(0xFF141414),
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 10),

              Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xFFD1D2D3), // Border color
                    width: 1, // Border width
                  ),
                  borderRadius: BorderRadius.circular(8.0), // Border radius
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 5, left: 5),
                    child: TextFormField(
                      controller: _text2,
                      obscureText: passwordVisible,
                      decoration: InputDecoration(
                        border: InputBorder.none,
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
                ),
              ),
              // can't be empty error text
              Visibility(
                visible: !_showErrorText,
                // Set visibility based on the condition
                child: const Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "can't be empty",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Nsut mail",
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Color(0xFF141414),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xFFD1D2D3), // Border color
                    width: 1, // Border width
                  ),
                  borderRadius: BorderRadius.circular(8.0), // Border radius
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 5, left: 5),
                    child: TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: 'Student@nsut.ac.in',
                        border: InputBorder.none,
                        fillColor: Colors.white,
                        alignLabelWithHint: false,
                        filled: true,
                      ),
                    ),
                  ),
                ),
              ),

              // can't be empty error text
              Visibility(
                visible: !_showErrorText,
                // Set visibility based on the condition
                child: const Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "can't be empty",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 70),

              Visibility(
                  visible: _showErrorText,
                  child: const SizedBox(
                    height: 20,
                  )),

              //Login Button

              ElevatedButton(
                onPressed: () {
                  final email = _emailController.text.trim();
                  final emailPattern =
                      RegExp(r'^[a-zA-Z0-9._%+-]+@nsut\.ac\.in$');

                  setState(() {
                    _showErrorText = false;
                    _validate = _text1.text.isEmpty ||
                        _text2.text.isEmpty ||
                        _emailController.text.isEmpty;
                  });

                  if (!_validate && emailPattern.hasMatch(email)) {
                    _showErrorText = true;

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            Emailverification(_emailController.text.toString()),
                      ),
                    );
                  } else {}
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2546A9),
                  // Set the background color here
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(48), // Set the border radius
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

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
