import 'package:amul/Utils/AppColors.dart';
import 'package:amul/screens/auth/auth_input_widget.dart';
import 'package:amul/screens/components/devcomm_logo.dart';
import 'package:amul/widgets/amulX_snackbars.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

  final emailPattern = RegExp(r'^[a-zA-Z0-9._%+-]+@nsut\.ac\.in$');
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _validteEmail(value) {
    if (value!.isEmpty) {
      return "Can't be empty";
    }
    if (!emailPattern.hasMatch(value)) {
      return "Please enter a valid email";
    }
    return null;
  }

  Future<void> resetpassword() async {
    String email = _emailController.text.toString();

    try {
      CollectionReference collection = db.collection('User');
      String documentId = email;
      var existingDocument = await collection.doc(documentId).get();

      if (existingDocument.exists) {
        await auth.sendPasswordResetEmail(email: email);
        AmulXSnackBars.showPasswordResetLinkSendSnackbar();
      } else {
        AmulXSnackBars.onPasswordResetAccountNotFoundSnackbar();
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
      resetpassword();
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: appColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: appColors.backgroundColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: appColors.blue,
          ),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 55,
                  ),
                  SvgPicture.asset(
                    'assets/images/logo.svg',
                    width: 200,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    "Please enter your email to reset your password",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: appColors.secondaryText,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    height: height / 14,
                  ),
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
                              Icons.email,
                              color: appColors.blue,
                            ),
                            controller: _emailController,
                            validator: _validteEmail,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: appColors.blue,
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
                                          color: AppColors.blue,
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
