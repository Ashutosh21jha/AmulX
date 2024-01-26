// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:amul/Utils/AppColors.dart';
import 'package:flutter/material.dart';

class Terms extends StatelessWidget {
  const Terms({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late final appColors = Theme.of(context).extension<AppColors2>()!;
    late final bool _isDarkMode =
        AdaptiveTheme.of(context).brightness == Brightness.dark ? true : false;

    return Scaffold(
        body: SingleChildScrollView(
            child: Column(children: [
      Container(
        height: 60,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xFF00084B),
              Color(0xFF2E55C0),
              Color(0xFF148BFA),
            ],
          ),
          /* borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(80),
                  bottomRight: Radius.circular(80),
                ),*/
        ),
      ),
      Container(
        height: 75,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xFF00084B),
              Color(0xFF2E55C0),
              Color(0xFF148BFA),
            ],
          ),
          /* borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(80),
                  bottomRight: Radius.circular(80),
                ),*/
        ),
        child: Center(
          child: Text(
            'Terms & Conditions',
            style: TextStyle(
              color: appColors.whiteText,
              fontSize: 20,
              fontFamily: 'Epilogue',
              fontWeight: FontWeight.w700,
              height: 0.06,
            ),
          ),
        ),
      ),
      Stack(children: [
        Container(
          height: 45,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xFF00084B),
                Color(0xFF2E55C0),
                Color(0xFF148BFA),
              ],
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.elliptical(40, 20),
              bottomRight: Radius.elliptical(40, 20),
            ),
          ),
        ),
        Align(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 80,
                ),
                Text(
                  'Devcomms Privacy Policy',
                  style: TextStyle(
                      fontSize: 18,
                      color: appColors.text2,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Epilogue'),
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'License to Use: By downloading or using the Amulx app, you are granted a limited, non-exclusive, non-transferable license to use the app for your personal, non-commercial use. The app and all associated content remain the property of the apps developers and/or licensors.',
                    style: TextStyle(
                        fontSize: 14,
                        color: appColors.text2,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Epilogue'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'In no event will the apps developers and/or licensors be liable for any direct, '
                    'indirect, incidental, special, consequential, or exemplary damages, '
                    'including but not limited to damages for loss of profits, goodwill, use, data, or other '
                    'intangible losses, arising out of or in connection with the Amulx app or any associated content.',
                    style: TextStyle(
                        fontSize: 14,
                        color: appColors.text2,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Epilogue'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'The Amulx app may collect certain personal information from you,'
                    ' such as your name, email address, and usage data.'
                    ' The apps developers and/or licensors will use this information in accordance with their privacy policy,'
                    ' which can be found on the apps website.',
                    style: TextStyle(
                        fontSize: 14,
                        color: appColors.text2,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Epilogue'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'The apps developers and/or licensors reserve the right to modify these terms and '
                    'conditions at any time, without notice. Your continued use of the Amulx app following any such '
                    'modifications will constitute your acceptance of the modified terms and conditions.',
                    style: TextStyle(
                        fontSize: 14,
                        color: appColors.text2,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Epilogue'),
                  ),
                ),
              ],
            ),
          ),
        )
      ])
    ])));
  }
}
