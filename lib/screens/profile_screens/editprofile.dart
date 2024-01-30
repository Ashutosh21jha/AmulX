import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import '../../Utils/AppColors.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key, required this.parentImageUrl}) : super(key: key);

  final RxString parentImageUrl;

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
  final overlayPortalController = OverlayPortalController();
  late final appColors = Theme.of(context).extension<AppColors2>()!;
  late final bool _isDarkMode =
      AdaptiveTheme.of(context).brightness == Brightness.dark ? true : false;

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

  Future<void> saveUrlLocally(String urlOfImage) async {
    Directory appDir = await getApplicationDocumentsDirectory();

    final urlFilePath = Uri.parse(appDir.path).resolve('urlFile.txt');

    final file = File(urlFilePath.toFilePath());

    file.writeAsString(urlOfImage);
  }

  Future<void> uploadImageToFirebase(XFile image) async {
    overlayPortalController.show();
    File imageFile = File(image.path);
    FirebaseStorage storage = FirebaseStorage.instance;
    var ref = storage.ref('user/pp_$userId.jpg');
    var metadata = await ref.getData().onError((error, stackTrace) {
      overlayPortalController.hide();
      return null;
    });
    if (metadata != null) {
      await storage.ref('user/pp_$userId.jpg').putFile(imageFile);
      setState(() {});
      final downloadUrl = await ref.getDownloadURL();
      setState(() {
        widget.parentImageUrl.value = downloadUrl;
      });
      saveUrlLocally(downloadUrl);
    } else {
      print("Image not found");
    }
    // try {
    //   await FirebaseStorage.instance
    //       .ref('user/pp_$userId.jpg')
    //       .putFile(imageFile);
    //   setState(() {});
    // } on FirebaseException catch (e) {
    //   print(e);
    // }
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

  // Future<ImageProvider> fetchImage() async {
  //   String filePath = 'user/pp_$userId.jpg';
  //   var ref = FirebaseStorage.instance.ref().child(filePath);
  //   FirebaseStorage storage = FirebaseStorage.instance;
  //   var refL = storage.ref('user/pp_$userId.jpg');
  //   var metadata = await refL.getData().onError((error, stackTrace) {
  //     return null;
  //   });
  //   if (metadata != null) {
  //     return ref.getDownloadURL().then((url) {
  //       return NetworkImage(url);
  //     });
  //   } else {
  //     return const AssetImage('assets/images/avatar.png');
  //   }
  //   // return ref.getDownloadURL().then((url) {
  //   //   return NetworkImage(url);
  //   // }, onError: (error) {
  //   //   return const AssetImage('assets/images/avatar.png');
  //   // });
  // }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        flexibleSpace: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFF00084B),
            Color(0xFF2E55C0),
            Color(0xFF148BFA),
          ],
        ))),
        title: const Text(
          "Edit profile",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontFamily: 'Epilogue',
            fontWeight: FontWeight.w700,
            height: 0.06,
          ),
        ),
        // leading: IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back)),
        centerTitle: true,
      ),
      // extendBodyBehindAppBar: true,
      body: OverlayPortal(
        controller: overlayPortalController,
        overlayChildBuilder: overlayChildBuilder,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              child: Container(
                  height: 100,
                  width: MediaQuery.sizeOf(context).width,
                  // color: AppColors.blue,
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color(0xFF00084B),
                      Color(0xFF2E55C0),
                      Color(0xFF148BFA),
                    ],
                  ))),
            ),
            Positioned(
                top: 200,
                child: Container(
                  width: MediaQuery.sizeOf(context).width,
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // const Text(
                        //   'Full Name',
                        //   style: TextStyle(
                        //     color: Color(0xFF141414),
                        //     fontSize: 16,
                        //     fontFamily: 'Epilogue',
                        //     fontWeight: FontWeight.w500,
                        //     height: 0.06,
                        //   ),
                        // ),
                        // const SizedBox(height: 8),
                        TextField(
                          controller: nameController,
                          decoration: InputDecoration(
                            labelText: 'Name',
                            labelStyle: TextStyle(
                              color: appColors.text2,
                              fontSize: 16,
                              fontFamily: 'Epilogue',
                              fontWeight: FontWeight.w500,
                              height: 0.06,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                width: 1,
                                color: Color(0xFFD1D2D3),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                width: 1,
                                color: Color(0xFFD1D2D3),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                width: 1,
                                color: Colors.blue,
                              ),
                            ),
                            filled: true,
                            fillColor: appColors.cardColor,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: SizedBox(
                            width: MediaQuery.sizeOf(context).width / 4,
                            child: TextButton(
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

                                // Get.back();
                              },
                              style: ButtonStyle(
                                padding: MaterialStateProperty.all(
                                    const EdgeInsets.symmetric(vertical: 16)),
                                backgroundColor: MaterialStateProperty.all(
                                    const Color(0xFF2546A9)),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(48),
                                  ),
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
                          ),
                        ),
                      ]),
                )),
            Positioned(
              top: 50,
              left: MediaQuery.of(context).size.width / 2 - 50,
              child: Stack(alignment: Alignment.bottomRight, children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(
                          widget.parentImageUrl.value),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
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
              ]),
            ),
            Positioned(
              bottom: 10,
              left: MediaQuery.of(context).size.width / 2 - 50,
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/devcommlogo_noBG.png',
                    height: 50,
                    width: 50,
                  ),
                  const Text(
                    "Powered by\nDevComm",
                    style: TextStyle(fontSize: 10),
                  ),
                ],
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 16),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.center,
            //     children: [
            //       Align(
            //         alignment: Alignment.topLeft,
            //         child: Column(
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             children: [
            //               const Text(
            //                 'Full Name',
            //                 style: TextStyle(
            //                   color: Color(0xFF141414),
            //                   fontSize: 16,
            //                   fontFamily: 'Epilogue',
            //                   fontWeight: FontWeight.w500,
            //                   height: 0.06,
            //                 ),
            //               ),
            //               const SizedBox(height: 8),
            //               TextField(
            //                 controller: nameController,
            //                 decoration: InputDecoration(
            //                   contentPadding: const EdgeInsets.symmetric(
            //                       vertical: 10, horizontal: 20),
            //                   border: OutlineInputBorder(
            //                     borderRadius: BorderRadius.circular(8),
            //                     borderSide: const BorderSide(
            //                       width: 1,
            //                       color: Color(0xFFD1D2D3),
            //                     ),
            //                   ),
            //                   enabledBorder: OutlineInputBorder(
            //                     borderRadius: BorderRadius.circular(8),
            //                     borderSide: const BorderSide(
            //                       width: 1,
            //                       color: Color(0xFFD1D2D3),
            //                     ),
            //                   ),
            //                   focusedBorder: OutlineInputBorder(
            //                     borderRadius: BorderRadius.circular(8),
            //                     borderSide: const BorderSide(
            //                       width: 1,
            //                       color: Colors.blue,
            //                     ),
            //                   ),
            //                   filled: true,
            //                   fillColor: Colors.white,
            //                 ),
            //               ),
            //               const SizedBox(height: 20),
            //               const Text(
            //                 'Profile Picture',
            //                 style: TextStyle(
            //                   color: Color(0xFF141414),
            //                   fontSize: 16,
            //                   fontFamily: 'Epilogue',
            //                   fontWeight: FontWeight.w500,
            //                   height: 0.06,
            //                 ),
            //               ),
            //               const SizedBox(height: 8),
            //               GestureDetector(
            //                 onTap: () {
            //                   pickImage();
            //                 },
            //                 child: FutureBuilder<ImageProvider>(
            //                   future: fetchImage(),
            //                   builder: (BuildContext context,
            //                       AsyncSnapshot<ImageProvider> snapshot) {
            //                     if (snapshot.connectionState ==
            //                         ConnectionState.waiting) {
            //                       return const SizedBox(
            //                         height: 60,
            //                         width: 60,
            //                         child: Center(
            //                           child: CircularProgressIndicator(
            //                             color: AppColors.blue,
            //                           ),
            //                         ),
            //                       );
            //                     } else {
            //                       return Container(
            //                         width: 100,
            //                         height: 100,
            //                         decoration: BoxDecoration(
            //                           color: Colors.grey,
            //                           borderRadius: BorderRadius.circular(8),
            //                           image: DecorationImage(
            //                             image: snapshot.data!,
            //                             fit: BoxFit.cover,
            //                           ),
            //                         ),
            //                       );
            //                     }
            //                   },
            //                 ),
            //               ),
            //               const SizedBox(height: 20),
            //               SizedBox(
            //                 width: double.infinity,
            //                 child: TextButton(
            //                   onPressed: () async {
            //                     await db.collection('User').doc(userId).update({
            //                       'name': nameController.text,
            //                     }).then((value) {
            //                       Get.snackbar(
            //                         'Success',
            //                         'Name Updated',
            //                         barBlur: 10,
            //                         backgroundGradient: const LinearGradient(
            //                           colors: [
            //                             Color(0xFFF98181),
            //                             AppColors.red,
            //                             Color(0xFF850000),
            //                           ],
            //                           begin: Alignment.topCenter,
            //                           end: Alignment.bottomCenter,
            //                         ),
            //                         duration: const Duration(seconds: 1),
            //                         icon: Image.asset(
            //                           'assets/images/devcommlogo.png',
            //                           width: 24,
            //                           height: 24,
            //                         ),
            //                       );
            //                     });

            //                     // Get.back();
            //                   },
            //                   style: ButtonStyle(
            //                     padding: MaterialStateProperty.all(
            //                         const EdgeInsets.symmetric(vertical: 16)),
            //                     backgroundColor: MaterialStateProperty.all(
            //                         const Color(0xFF2546A9)),
            //                     shape: MaterialStateProperty.all(
            //                       RoundedRectangleBorder(
            //                         borderRadius: BorderRadius.circular(48),
            //                       ),
            //                     ),
            //                   ),
            //                   child: InkWell(
            //                     onTap: () {},
            //                     child: const Text(
            //                       'Save',
            //                       textAlign: TextAlign.justify,
            //                       style: TextStyle(
            //                         color: Colors.white,
            //                         fontSize: 16,
            //                         fontFamily: 'Epilogue',
            //                         fontWeight: FontWeight.w500,
            //                         height: 0.06,
            //                       ),
            //                     ),
            //                   ),
            //                 ),
            //               )
            //             ]),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
