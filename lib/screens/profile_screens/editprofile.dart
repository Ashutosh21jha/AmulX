// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
  String get userId => auth.currentUser?.email ?? '';
  String? imageUrl;
  late TextEditingController nameController;
  String name = '';

  @override
  void initState() {
    super.initState();
    fetchImageUrl();
    receivedata();
    nameController = TextEditingController(text: name);
  }

  Future<void> receivedata() async {
    final docRef = await db.collection("User").doc(userId).get();
    Map<String, dynamic>? userData = docRef.data();
    if (userData != null) {
      setState(() {
        name = userData['name'] ?? '';
        nameController = TextEditingController(text: name);
      });
    }
  }

  Future<void> submit() async {
    await db.collection('User').doc(userId).update({
      'name': nameController.text,
    });
  }

  Future<void> uploadImageToFirebase(XFile image) async {
    File imageFile = File(image.path);

    try {
      await FirebaseStorage.instance
          .ref('user/pp_$userId.jpg')
          .putFile(imageFile);
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  Future<void> pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery, maxWidth: 500, maxHeight: 500);

    if (image != null) {
      uploadImageToFirebase(image);
    }
  }

  Future<void> fetchImageUrl() async {
    try {
      String downloadURL = await FirebaseStorage.instance
          .ref('user/pp_$userId.jpg')
          .getDownloadURL();

      setState(() {
        imageUrl = downloadURL;
      });
    } catch (e) {
      imageUrl = 'assets/images/avatar.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 80),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Edit profile",
                        style: TextStyle(
                          color: const Color.fromARGB(255, 0, 0, 0),
                          fontSize: 18,
                          fontFamily: 'Epilogue',
                          fontWeight: FontWeight.w700,
                          height: 0.06,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40),
                Align(
                  alignment: Alignment.topLeft,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Full Name',
                          style: TextStyle(
                            color: Color(0xFF141414),
                            fontSize: 16,
                            fontFamily: 'Epilogue',
                            fontWeight: FontWeight.w500,
                            height: 0.06,
                          ),
                        ),
                        SizedBox(height: 8),
                        TextField(
                          controller: nameController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                width: 1,
                                color: Color(0xFFD1D2D3),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                width: 1,
                                color: Color(0xFFD1D2D3),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                width: 1,
                                color: Colors.blue,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Profile Picture',
                          style: TextStyle(
                            color: Color(0xFF141414),
                            fontSize: 16,
                            fontFamily: 'Epilogue',
                            fontWeight: FontWeight.w500,
                            height: 0.06,
                          ),
                        ),
                        SizedBox(height: 8),
                        GestureDetector(
                          onTap: () {
                            pickImage();
                          },
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: imageUrl != null
                                    ? NetworkImage(imageUrl!)
                                    : AssetImage('assets/images/avatar.png')
                                        as ImageProvider<Object>,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: TextButton(
                            onPressed: submit,
                            style: ButtonStyle(
                              padding: MaterialStateProperty.all(
                                  const EdgeInsets.symmetric(vertical: 16)),
                              backgroundColor:
                                  MaterialStateProperty.all(Color(0xFF2546A9)),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(48),
                                ),
                              ),
                            ),
                            child: Text(
                              'Save',
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: 'Epilogue',
                                fontWeight: FontWeight.w500,
                                height: 0.06,
                              ),
                            ),
                          ),
                        )
                      ]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
