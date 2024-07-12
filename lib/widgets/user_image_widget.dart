import 'package:amul/Utils/AppColors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserImageWidget extends StatelessWidget {
  const UserImageWidget({super.key, required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final AppColors2 appColors = Theme.of(context).extension<AppColors2>()!;
    if (imageUrl.isNotEmpty) {
      return ClipOval(
        child: CachedNetworkImage(
            fit: BoxFit.cover,
            height: 64,
            width: 64,
            placeholder: (_, __) => SizedBox(
                  height: 60,
                  width: 60,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: appColors.blue,
                    ),
                  ),
                ),
            imageUrl: imageUrl,
            cacheKey: imageUrl),
      );
    } else {
      return SizedBox(
          height: 64,
          width: 64,
          child: ClipOval(
            child: Image.asset(
              'assets/images/avatar.png',
              fit: BoxFit.cover,
              height: 64,
              width: 64,
            ),
          ));
    }
  }
}
