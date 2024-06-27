import 'dart:io';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:amul/Utils/AppColors.dart';
import 'package:amul/controllers/user_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ProfileCard2 extends StatefulWidget {
  const ProfileCard2({super.key});

  @override
  State<ProfileCard2> createState() => _ProfileCard2State();
}

class _ProfileCard2State extends State<ProfileCard2> {
  late UserController userController = Get.find<UserController>();

  late final bool _isDarkMode =
      AdaptiveTheme.of(context).brightness == Brightness.dark ? true : false;
  final List<BoxShadow> _shadows = [
    const BoxShadow(
      color: Color(0x28606170),
      blurRadius: 4,
      offset: Offset(0, 2),
      spreadRadius: 0,
    ),
    const BoxShadow(
      color: Color(0x0A28293D),
      blurRadius: 1,
      offset: Offset(0, 0),
      spreadRadius: 0,
    )
  ];
  // Future<void> pickImage() async {
  //   final ImagePicker picker = ImagePicker();
  //   final XFile? image = await picker.pickImage(
  //       source: ImageSource.gallery, maxWidth: 500, maxHeight: 500);

  //   if (image != null) {
  //     // uploadImageToFirebase(image);
  //   }
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: MediaQuery.of(context).size.width * .6,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
      decoration: ShapeDecoration(
        color: _isDarkMode ? Colors.grey.shade200 : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        shadows: _shadows,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Obx(
            () {
              if (userController.imageUrl.value.isNotEmpty) {
                return ClipOval(
                  child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      height: 64,
                      width: 64,
                      imageUrl: userController.imageUrl.value,
                      cacheKey: userController.imageUrl.value),
                );
              } else {
                return const SizedBox(
                  height: 60,
                  width: 60,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.blue,
                    ),
                  ),
                );
              }
            },
          ),
          const SizedBox(width: 16),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userController.userName.value,
                style: const TextStyle(
                  color: Color(0xFF414042),
                  fontSize: 18,
                  fontFamily: 'Epilogue',
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                userController.studentId.value,
                style: const TextStyle(
                  color: Color(0xFF57585B),
                  fontSize: 14,
                  fontFamily: 'Epilogue',
                  fontWeight: FontWeight.w400,
                  height: 0.07,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          )
        ],
      ),
    );
  }
}
