// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:amul/Utils/AppColors.dart';
import 'package:amul/widgets/amulX_appbar.dart';
import 'package:flutter/material.dart';

class About extends StatelessWidget {
  const About({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late final appColors = Theme.of(context).extension<AppColors2>()!;

    return Scaffold(
        body: SingleChildScrollView(
            child: Column(children: [
      AmulXAppBar(
        title: "About Us",
        showBackArrow: true,
        bottomRoundedCorners: true,
        bottomPadding: EdgeInsets.only(bottom: 45),
      ),
      SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              SizedBox(
                height: 40,
              ),
              Text(
                'Amulx is an app made by the largest tech society of NSUT, Devcomm.',
                style: TextStyle(
                    fontSize: 16,
                    color: appColors.primaryText,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Epilogue'),
              ),
            ],
          ),
        ),
      ),
    ])));
  }
}
