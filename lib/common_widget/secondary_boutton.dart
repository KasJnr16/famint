import 'package:fanmint/utility/constants/colors.dart';
import 'package:fanmint/utility/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class SecondaryButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final double fontSize;
  final FontWeight fontWeight;
  const SecondaryButton(
      {super.key,
      required this.title,
      this.fontSize = 14,
      this.fontWeight = FontWeight.w600,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
            image: const DecorationImage(
              image: AssetImage("assets/img/secodry_btn.png"),
            ),
            borderRadius: BorderRadius.circular(30),
            border: Border.fromBorderSide(BorderSide(
                color: HelperFunctions.isDarkMode(context)
                    ? Colors.transparent
                    : UniColors.primary))),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(fontSize: fontSize, fontWeight: fontWeight),
        ),
      ),
    );
  }
}
