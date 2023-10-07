import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  final _text2 = TextEditingController();
  bool _validate = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _showErrorText = true;
    });
    passwordVisible = true;
  }

  @override
  void dispose() {
    _text1.dispose();
    _text2.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Container(
          // color: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 24,vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 90,
              ),
              Center(
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
              Center(
                child: const Text(
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
                width: 330,
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xFFD1D2D3), // Border color
                    width: 1, // Border width
                  ),
                  borderRadius:
                  BorderRadius.circular(8.0), // Border radius
                ),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(right: 5, left: 5),
                    child: TextField(
                      controller: _text1,
                      decoration: InputDecoration(
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
                child: Align(
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
                  child: SizedBox(
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
                width: 330,
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xFFD1D2D3), // Border color
                    width: 1, // Border width
                  ),
                  borderRadius:
                  BorderRadius.circular(8.0), // Border radius
                ),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(right: 5, left: 5),
                    child: TextField(
                      controller: _text2,
                      obscureText: passwordVisible,
                      decoration: InputDecoration(
                        /*errorText: _validate ? 'Input Valid Info' : null,*/

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
                child: Align(
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
                  child: SizedBox(
                    height: 20,
                  )),

              //Login Button

              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _text1.text.isEmpty
                        ? _validate = true
                        : _validate = false;
                    _text2.text.isEmpty
                        ? _validate = true
                        : _validate = false;
                    _showErrorText = false;
                  });
                  if (!_validate) {
                    _showErrorText = true;
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Home(),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2546A9),
                  // Set the background color here
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        48), // Set the border radius
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
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
