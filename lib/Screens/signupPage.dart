import 'package:amul/screens/mainscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

FirebaseFirestore db = FirebaseFirestore.instance;
FirebaseAuth auth = FirebaseAuth.instance;

Future<void> sendEmailVerification() async {
  await auth.currentUser?.sendEmailVerification();
}

Future<void> signUp(
    {required String email,
    required String password,
    required String rollno,
    required String name,
    required BuildContext context}) async {
  try {
    CollectionReference collection = db.collection('User');
    String documentId = email;

// Check if the document with the specified ID already exists
    var existingDocument = await collection.doc(documentId).get();

    if (existingDocument.exists) {
      /* print('Document with ID $documentId already exists');*/
      /*ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
          content: Text("Document with ID  ${email} already exists "),
        ),
      );*/

      Map<String, dynamic>? userData =
          existingDocument.data() as Map<String, dynamic>?;
      if (userData != null &&
          userData['name'] == name &&
          userData['roll number'] == rollno &&
          userData['password'] == password) {
        signIn(email: email, password: password);
        print(auth.currentUser?.email);
        sendEmailVerification();
        /*auth.sendSignInLinkToEmail(email: email, actionCodeSettings: null);*/
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const Mainscreen()),
          (route) => false,
        );
      } else {
        // Values don't match, handle accordingly
        if ((userData != null &&
            userData['name'] == name &&
            userData['roll number'] == rollno &&
            userData['password'] != password)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Wrong password"),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Invalid info"),
            ),
          );
        }
      }
    } else {
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);

      sendEmailVerification();

      await auth.currentUser?.updateDisplayName(name);

      String? userUid = FirebaseAuth.instance.currentUser?.uid;

      await db.collection('User').doc(email).set({
        "name": name,
        "roll number": rollno,
        "userUid": userUid,
      }).catchError((error) {
        print("Error adding data: $error");
      });
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const Mainscreen()),
          (route) => false);
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

Future<void> signIn({
  required String email,
  required String password,
}) async {
  try {
    await auth.signInWithEmailAndPassword(email: email, password: password);
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      throw Exception('No user found for that email.');
    } else if (e.code == 'wrong-password') {
      throw Exception('Wrong password provided for that user.');
    }
  }
}

class signupPage extends StatefulWidget {
  const signupPage({super.key});

  @override
  State<signupPage> createState() => _signupPageState();
}

class _signupPageState extends State<signupPage> {
  bool passwordVisible = false;
  final _id = TextEditingController();
  final _emailController = TextEditingController();
  final _password = TextEditingController();
  final _name = TextEditingController();

  // student id pattern
  RegExp pattern = RegExp(r'^\d{4}[A-Za-z]{3}\d{4}$');

  // email pattern
  final emailPattern = RegExp(r'^[a-zA-Z0-9._%+-]+@nsut\.ac\.in$');

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _submitform() {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text.toString();
      String name = _name.text.toString();
      String rollno = _id.text.toString();
      String password = _password.text.toString();

      // creating user if not already exists
      signUp(
          email: email,
          context: context,
          name: name,
          password: password,
          rollno: rollno);
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
                height: 50,
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
                      "Name",
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
                          fillColor: Colors.white,
                          hintText: "e.g. userName",
                          alignLabelWithHint: false,
                          filled: true,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
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
                    const SizedBox(height: 10),
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
                    const SizedBox(height: 50),
                    ElevatedButton(
                      onPressed: () => _submitform(),
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
