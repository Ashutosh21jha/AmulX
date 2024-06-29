import 'package:amul/Utils/AppColors.dart';
import 'package:amul/widgets/custom_shape.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';

class AmulXAppBar extends StatelessWidget {
  const AmulXAppBar({super.key, this.children = const <Widget>[]});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    late final AppColors2 appColors =
        Theme.of(context).extension<AppColors2>()!;
    return Stack(children: [
      CustomPaint(
        size: Size(MediaQuery.of(context).size.width, 250),
        painter: RPSCustomPainter(),
      ),

      // SvgPicture.asset('assets/images/shape.svg'),
      Container(
        height: 10,
        width: double.infinity,
        color: appColors.blue,
      ),
      Positioned(
          top: 100,
          left: 20,
          child: SvgPicture.asset(
            'assets/images/logo.svg',
            width: 40,
            height: 40,
            color: appColors.onPrimary,
          )),
      ...children
    ]);
  }
}
