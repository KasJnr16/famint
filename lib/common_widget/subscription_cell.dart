import 'package:fanmint/utility/constants/colors.dart';
import 'package:fanmint/utility/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

import '../common/color_extension.dart';

class SubScriptionCell extends StatelessWidget {
  final Map sObj;
  final VoidCallback onPressed;

  const SubScriptionCell(
      {super.key, required this.sObj, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunctions.isDarkMode(context);
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          border: Border.all(
            color: dark ? TColor.border.withOpacity(0.1) : UniColors.light,
          ),
          color: dark ? TColor.gray60.withOpacity(0.2) : UniColors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              sObj["icon"],
              width: 45,
              height: 45,
            ),
            const Spacer(),
            Text(
              sObj["name"],
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              width: 8,
            ),
            Text(
              "\$${sObj["price"]}",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            )
          ],
        ),
      ),
    );
  }
}
