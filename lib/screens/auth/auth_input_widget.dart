import 'package:amul/Utils/AppColors.dart';
import 'package:flutter/material.dart';

class AuthInputWidget extends StatelessWidget {
  const AuthInputWidget(
      {super.key,
      required this.hintText,
      required this.label,
      required this.icon,
      required this.keyboardType,
      required this.validator,
      required this.controller,
      this.bottomPadding = 24,
      this.obscureText = false});
  final String hintText;
  final String label;
  final Widget icon;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?) validator;
  final double bottomPadding;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors2>()!;

    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 0, bottomPadding),
      child: TextFormField(
          // autovalidateMode: AutovalidateMode.onUserInteraction,
          style: TextStyle(color: appColors.primaryText),
          controller: controller,
          validator: validator,
          obscureText: obscureText,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            hintText: hintText,
            filled: true,
            fillColor: appColors.surfaceColor,
            suffixIcon: icon,
            label: Text(label, style: TextStyle(color: appColors.primaryText)),
            hintStyle: TextStyle(color: appColors.secondaryText),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              // borderSide: BorderSide(color: appColors.secondaryText),
            ),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide:
                    BorderSide(color: Colors.redAccent.withOpacity(0.87))),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide:
                    BorderSide(color: Colors.redAccent.withOpacity(0.87))),
          )),
    );
  }
}
