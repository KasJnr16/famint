
import 'package:fanmint/utility/constants/colors.dart';
import 'package:fanmint/utility/constants/sizes.dart';
import 'package:fanmint/utility/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class OptionCard extends StatelessWidget {
  const OptionCard({
    super.key,
    this.onTap,
    required this.title,
    required this.subTitle,
    required this.icon,
  });

  final void Function()? onTap;
  final String title, subTitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: UniColors.darkGrey),
            color: HelperFunctions.isDarkMode(context) ? UniColors.dark : null,
            borderRadius: BorderRadius.circular(UniSizes.borderRadius)),
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(UniSizes.md),
          child: Row(
            children: [
              Icon(icon),
              SizedBox(
                width: UniSizes.spaceBtwItems,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    subTitle,
                    style: Theme.of(context).textTheme.labelMedium,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
