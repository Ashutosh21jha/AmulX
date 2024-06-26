import 'package:amul/screens/signinPage.dart';
import 'package:amul/screens/signupPage.dart';
import 'package:flutter/material.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {

  bool showLoginPage = true;

  void togglePages(){
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }
  @override
  Widget build(BuildContext context) {
    if(showLoginPage){
      print(showLoginPage);
      return SignInPage(showSignupPage: togglePages);
    }
    else{
      print(showLoginPage);
      return SignUpPage(showSigninPage: togglePages);
    }
  }
}
