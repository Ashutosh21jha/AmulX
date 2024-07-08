import 'package:amul/Utils/AppColors.dart';
import 'package:amul/widgets/custom_shape.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';

class AmulXAppBar extends StatelessWidget {
  const AmulXAppBar(
      {super.key,
      required this.title,
      this.showBackArrow = true,
      this.bottomRoundedCorners = false,
      this.bottomPadding = const EdgeInsets.only(bottom: 0),
      this.children = const <Widget>[]});

  final List<Widget> children;
  final String title;
  final bool showBackArrow;
  final EdgeInsets bottomPadding;
  final bool bottomRoundedCorners;

  @override
  Widget build(BuildContext context) {
    late final AppColors2 appColors =
        Theme.of(context).extension<AppColors2>()!;

    return Container(
      alignment: Alignment.bottomCenter,
      height:
          (MediaQuery.of(context).size.height * 0.16) + bottomPadding.bottom,
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * 0.08,
          bottom: bottomPadding.bottom),
      decoration: BoxDecoration(
        borderRadius: bottomRoundedCorners
            ? const BorderRadius.only(
                bottomLeft: Radius.elliptical(40, 20),
                bottomRight: Radius.elliptical(40, 20),
              )
            : null,
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFF00084B),
            Color(0xFF2E55C0),
            Color(0xFF148BFA),
          ],
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          showBackArrow
              ? Positioned(
                  left: MediaQuery.of(context).size.width * 0.02,
                  child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: appColors.onPrimary,
                      )),
                )
              : const SizedBox.shrink(),

          // SizedBox(width: MediaQuery.of(context).size.width * 0.27),
          Align(
            alignment: Alignment.center,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: appColors.onPrimary,
                fontSize: 18,
                fontFamily: 'Epilogue',
                fontWeight: FontWeight.w700,
                height: 0.06,
              ),
            ),
          ),
          ...children
        ],
      ),
    );
  }
}
