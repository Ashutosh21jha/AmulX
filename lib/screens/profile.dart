import 'package:amul/Utils/AppColors.dart';
import 'package:amul/screens/signupPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'profile_screens/about.dart';
import 'profile_screens/terms.dart';
import 'profile_screens/privacy.dart';
import 'profile_screens/editprofile.dart';
import 'profile_screens/faq.dart';
import 'dart:io';
import 'profile_screens/profile_card.dart';
import 'package:firebase_storage/firebase_storage.dart';

final auth = FirebaseAuth.instance;
final db = FirebaseFirestore.instance;

String get userId => auth.currentUser?.email ?? '';

Future<void> signOut() async {
  try {
    print(auth.currentUser?.uid);
    await auth.signOut();
  } catch (e) {
    throw Exception(e);
  }
}

const EdgeInsets _paddingButtons =
    EdgeInsets.symmetric(horizontal: 12, vertical: 8);

const List<BoxShadow> _shadows = [
  BoxShadow(
    color: Color(0x28606170),
    blurRadius: 4,
    offset: Offset(0, 2),
    spreadRadius: 0,
  ),
  BoxShadow(
    color: Color(0x0A28293D),
    blurRadius: 1,
    offset: Offset(0, 0),
    spreadRadius: 0,
  )
];

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String name = "";
  String s_id = "";
  String? imageUrl;

  @override
  void initState() {
    super.initState();
    receivedata();
  }

  Future<void> uploadImageToFirebase(XFile image) async {
    File imageFile = File(image.path);

    try {
      await FirebaseStorage.instance
          .ref('user/pp_$userId.jpg')
          .putFile(imageFile);
      setState(() {});
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

  Future<void> receivedata() async {
    final docRef = await db.collection("User").doc(userId).get();
    Map<String, dynamic>? userData = docRef.data() as Map<String, dynamic>?;
    if (userData != null) {
      setState(() {
        name = userData['name'] ?? '';
        s_id = userData['student id'] ?? '';
      });
    }
  }

  Stream<ImageProvider> getProfilePicture() async* {
    FirebaseStorage storage = FirebaseStorage.instance;
    while (true) {
      try {
        String downloadURL =
            await storage.ref('user/pp_$userId.jpg').getDownloadURL();
        yield NetworkImage(downloadURL);
      } catch (e) {
        // The file doesn't exist
        yield const AssetImage('assets/images/avatar.png');
      }
      await Future.delayed(const Duration(seconds: 2));
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
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.25,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF00074B),
                  Color(0xFF2D55C0),
                  Color(0xFF2D55C0),
                  Color(0xFF138BF9)
                ],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
            ),
          ),
          Align(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 80),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'My Profile',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'Epilogue',
                          fontWeight: FontWeight.w700,
                          height: 0.06,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  // PROFILE CARD
                  Container(
                    width: 327,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: ShapeDecoration(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      shadows: _shadows,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 60,
                              height: 60,
                              child: Stack(
                                children: [
                                  Positioned(
                                      left: 0,
                                      top: 0,
                                      child: StreamBuilder<ImageProvider>(
                                        stream: getProfilePicture(),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<ImageProvider>
                                                snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const SizedBox(
                                              height: 60,
                                              width: 60,
                                              child: Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  color: AppColors.blue,
                                                ),
                                              ),
                                            );
                                          } else {
                                            return Stack(
                                              children: [
                                                Container(
                                                  width: 60,
                                                  height: 60,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    image: DecorationImage(
                                                      image: snapshot.data!,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  bottom: 0,
                                                  right: 0,
                                                  child: Container(
                                                    width: 22,
                                                    height: 22,
                                                    decoration:
                                                        const BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: AppColors.yellow,
                                                    ),
                                                    child: InkWell(
                                                      onTap: () {
                                                        pickImage();
                                                      },
                                                      child: const Icon(
                                                        Icons.edit,
                                                        color: Colors.white,
                                                        size: 12,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          }
                                        },
                                      )),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: const TextStyle(
                                color: Color(0xFF414042),
                                fontSize: 18,
                                fontFamily: 'Epilogue',
                                fontWeight: FontWeight.w700,
                                height: 0.06,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              s_id,
                              style: const TextStyle(
                                color: Color(0xFF57585B),
                                fontSize: 14,
                                fontFamily: 'Epilogue',
                                fontWeight: FontWeight.w400,
                                height: 0.07,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  const SizedBox(
                    width: 327,
                    child: Text(
                      'Account',
                      style: TextStyle(
                        color: Color(0xFF57585B),
                        fontSize: 14,
                        fontFamily: 'Epilogue',
                        fontWeight: FontWeight.w500,
                        height: 0.08,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // PROFILE
                  ProfileCard(
                      icon: Icons.person,
                      text: "Profile",
                      screen: const EditProfile(),
                      color: const Color(0xFFA287F8)),
                  const SizedBox(height: 16),
                  // ABOUT US
                  ProfileCard(
                      icon: Icons.info_outline,
                      text: "About Us",
                      screen: const About(),
                      color: const Color(0xFF02B9F0)),
                  const SizedBox(height: 16),
                  // FAQ
                  ProfileCard(
                      icon: Icons.question_answer_outlined,
                      text: "FAQ",
                      screen: const Faq(),
                      color: const Color(0xFFFC6DBB)),
                  const SizedBox(height: 16),
                  // TERMS AND CONDITION
                  ProfileCard(
                      icon: Icons.file_copy,
                      text: "Terms and Conditions",
                      screen: const Terms(),
                      color: const Color(0xFF3BA889)),
                  const SizedBox(height: 16),
                  // PRIVACY POLICY
                  ProfileCard(
                      icon: Icons.shield_outlined,
                      text: "Privacy Policy",
                      screen: const Privacy(),
                      color: const Color(0xFFFBBC04)),
                  const SizedBox(height: 16),
                  // LOGOUT
                  InkWell(
                    onTap: () => signOut().then((value) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const signupPage(),
                          ));
                    }),
                    child: Container(
                      width: 327,
                      padding: _paddingButtons,
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                              width: 1, color: Color(0xFFF3F3F3)),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        shadows: _shadows,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: ShapeDecoration(
                              color: const Color(0xFFF57878),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 24,
                                      height: 24,
                                      clipBehavior: Clip.antiAlias,
                                      decoration: const BoxDecoration(),
                                      child: const Icon(
                                        Icons.logout,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Expanded(
                            child: SizedBox(
                              child: Text(
                                'Logout',
                                style: TextStyle(
                                  color: Color(0xFFF46363),
                                  fontSize: 16,
                                  fontFamily: 'Epilogue',
                                  fontWeight: FontWeight.w400,
                                  height: 0.08,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          const SizedBox(
                            width: 16,
                            height: 16,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ]),
          ),
        ],
      ),
    );
  }
}
