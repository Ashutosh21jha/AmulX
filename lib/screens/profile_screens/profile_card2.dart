import 'package:amul/Utils/AppColors.dart';
import 'package:amul/controllers/user_controller.dart';
import 'package:amul/widgets/user_image_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ProfileCard2 extends StatelessWidget {
  ProfileCard2({super.key});

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

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.find<UserController>();
    final AppColors2 appColors = Theme.of(context).extension<AppColors2>()!;

    return Container(
      // width: MediaQuery.of(context).size.width * .6,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
      decoration: ShapeDecoration(
        color: Get.isDarkMode ? const Color(0xFF282828) : Colors.white,
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
              return UserImageWidget(
                imageUrl: userController.imageUrl.value,
              );
            },
          ),
          const SizedBox(width: 16),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userController.userName.value,
                style: TextStyle(
                  color: appColors.primaryText,
                  fontSize: 18,
                  fontFamily: 'Epilogue',
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                userController.studentId.value,
                style: TextStyle(
                  color: appColors.primaryText,
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
