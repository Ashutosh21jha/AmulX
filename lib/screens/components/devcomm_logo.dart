import 'package:amul/Utils/AppColors.dart';
import 'package:flutter/material.dart';

class DevcommLogo extends StatelessWidget {
  const DevcommLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Powered By",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 14,
                color:
                    Theme.of(context).extension<AppColors2>()!.secondaryText),
          ),
          Image.asset(
            'assets/images/devcommlogo_noBG.png',
            height: 64,
            width: 64,
          )
        ],
      ),
    );
  }
}
