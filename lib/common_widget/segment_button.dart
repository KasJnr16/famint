import 'package:fanmint/utility/constants/colors.dart';
import 'package:fanmint/utility/constants/sizes.dart';
import 'package:fanmint/utility/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

import '../common/color_extension.dart';

class SegmentButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final bool isActive;
  const SegmentButton(
      {super.key,
      required this.title,
      required this.isActive,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(UniSizes.borderRadius),
      onTap: onPressed,
      child: Container(
        decoration: isActive
            ? BoxDecoration(
                border: Border.all(
                  color: HelperFunctions.isDarkMode(context)
                      ? TColor.border.withOpacity(0.15)
                      : UniColors.white,
                ),
                color: HelperFunctions.isDarkMode(context)
                    ? TColor.gray60.withOpacity(0.2)
                    : UniColors.white,
                borderRadius: BorderRadius.circular(12),
              )
            : null,
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
              color: isActive ? null : TColor.gray30,
              fontSize: 12,
              fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
