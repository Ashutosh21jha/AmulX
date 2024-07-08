import 'package:amul/Utils/AppColors.dart';
import 'package:amul/widgets/amulX_appbar.dart';
import 'package:flutter/material.dart';

class Terms extends StatelessWidget {
  const Terms({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late final appColors = Theme.of(context).extension<AppColors2>()!;

    return Scaffold(
        body: SingleChildScrollView(
            child: Column(children: [
      const AmulXAppBar(title: "Terms & Conditions"),
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              // Text(
              //   'Devcomms Privacy Policy',
              //   style: TextStyle(
              //       fontSize: 18,
              //       color: appColors.secondaryText,
              //       fontWeight: FontWeight.w900,
              //       fontFamily: 'Epilogue'),
              // ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'License to Use: By downloading or using the Amulx app, you are granted a limited, non-exclusive, non-transferable license to use the app for your personal, non-commercial use. The app and all associated content remain the property of the apps developers and/or licensors.',
                  style: TextStyle(
                      fontSize: 14,
                      color: appColors.primaryText,
                      fontWeight: FontWeight.w500,
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
                      color: appColors.primaryText,
                      fontWeight: FontWeight.w500,
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
                      color: appColors.primaryText,
                      fontWeight: FontWeight.w500,
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
                      color: appColors.primaryText,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Epilogue'),
                ),
              ),
            ],
          ),
        ),
      )
    ])));
  }
}
