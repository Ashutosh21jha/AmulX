import 'package:amul/controllers/user_controller.dart';
import 'package:amul/screens/auth/auth_input_widget.dart';
import 'package:amul/screens/components/devcomm_logo.dart';
import 'package:amul/widgets/amulX_appbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import '../../Utils/AppColors.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
  final overlayPortalController = OverlayPortalController();
  late final appColors = Theme.of(context).extension<AppColors2>()!;

  final UserController userController = Get.find<UserController>();

  String get userId => auth.currentUser?.email ?? '';
  String? imageUrl;
  late TextEditingController nameController;
  String name = '';

  @override
  void initState() {
    super.initState();
    receivedata();
    nameController = TextEditingController(text: name);
  }

  Widget overlayChildBuilder(BuildContext ctx) {
    return Container(
      height: MediaQuery.sizeOf(context).height,
      width: MediaQuery.sizeOf(context).width,
      color: Colors.blueGrey.shade300.withAlpha(120),
      child: const Center(
        child: CircularProgressIndicator(
          color: AppColors.blue,
        ),
      ),
    );
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
    overlayPortalController.show();
    File imageFile = File(image.path);
    FirebaseStorage storage = FirebaseStorage.instance;
    var ref = storage.ref('user/pp_$userId.jpg');

    await ref.putFile(imageFile);
    final downloadUrl = await ref.getDownloadURL();

    await db.collection('User').doc(userController.email.value).update({
      'imageUrl': downloadUrl,
    });

    userController.imageUrl.value = downloadUrl;

    overlayPortalController.hide();
    Get.snackbar(
      'Success',
      'Profile Image Updated',
      barBlur: 10,
      backgroundGradient: const LinearGradient(
        colors: [
          Color(0xFFF98181),
          AppColors.red,
          Color(0xFF850000),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      duration: const Duration(seconds: 1),
      icon: Image.asset(
        'assets/images/icon.png',
        width: 24,
        height: 24,
      ),
    );
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
        source: ImageSource.gallery, maxWidth: 500, maxHeight: 500);

    if (image != null) {
      uploadImageToFirebase(image);
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
      // extendBodyBehindAppBar: true,
      body: OverlayPortal(
          controller: overlayPortalController,
          overlayChildBuilder: overlayChildBuilder,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                children: [
                  const AmulXAppBar(
                    title: "Edit Profile",
                    bottomRoundedCorners: true,
                    bottomPadding: EdgeInsets.only(bottom: 45),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 16, right: 16, top: 32),
                    child: Column(
                      children: [
                        Stack(children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: CachedNetworkImageProvider(
                                    userController.imageUrl.value),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: const BoxDecoration(
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
                        ]),
                        const SizedBox(
                          height: 16,
                        ),
                        AuthInputWidget(
                            hintText: "Name",
                            label: "Name",
                            icon: const Icon(Icons.person_rounded),
                            keyboardType: TextInputType.name,
                            validator: (_) => null,
                            controller: nameController),
                        ElevatedButton(
                          onPressed: () async {
                            overlayPortalController.show();
                            await db.collection('User').doc(userId).update({
                              'name': nameController.text,
                            }).then((value) {
                              Get.snackbar(
                                'Success',
                                'Name Updated',
                                barBlur: 10,
                                backgroundGradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFF98181),
                                    AppColors.red,
                                    Color(0xFF850000),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                                duration: const Duration(seconds: 1),
                                icon: Image.asset(
                                  'assets/images/icon.png',
                                  width: 24,
                                  height: 24,
                                ),
                              );
                              overlayPortalController.hide();
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 32),
                            backgroundColor: appColors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(48),
                            ),
                          ),
                          child: InkWell(
                            onTap: () {},
                            child: const Text(
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
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const DevcommLogo()
            ],
          )),
    );
  }
}
