import 'package:amul/Utils/AppColors.dart';
import 'package:amul/controllers/items_controller.dart';
import 'package:amul/screens/foodPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeFoodTile extends StatelessWidget {
  const HomeFoodTile({super.key, required this.title, required this.imageUrl});

  final String title;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors2>()!;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            Get.to(
              () => FoodPage(
                cat: "Food",
                itemList: ItemController.to.food,
              ),
            );
          },
          child: Card(
            color: appColors.surfaceColor,
            elevation: 4,
            shape: const CircleBorder(),
            surfaceTintColor: Colors.transparent,
            child: SizedBox(
              width: 134.5,
              height: 134.5,
              child: Center(
                child: Image.asset(
                  imageUrl,
                  fit: BoxFit.contain,
                  width: 80,
                  height: 83,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 6.5,
        ),
        Text(
          title,
          style: TextStyle(
            color: appColors.primaryText,
            fontSize: 14,
          ),
        )
      ],
    );
  }
}
