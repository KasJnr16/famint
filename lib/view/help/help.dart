import 'package:fanmint/common_widget/section_heading.dart';
import 'package:fanmint/utility/constants/colors.dart';
import 'package:fanmint/utility/constants/sizes.dart';
import 'package:fanmint/utility/helpers/helper_functions.dart';
import 'package:fanmint/view/settings/settings_view.dart';
import 'package:flutter/material.dart';
import 'package:fanmint/common/color_extension.dart';
import 'package:get/get.dart';

class HelpView extends StatelessWidget {
  const HelpView({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunctions.isDarkMode(context);

    return Scaffold(
      backgroundColor: dark ? TColor.gray : UniColors.white,
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(UniSizes.defaultSpace),
        child: Column(
          children: [
            //Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Help",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                IconButton(
                    onPressed: () => Get.to(() => const SettingsView()),
                    icon: Icon(Icons.settings))
              ],
            ),
            SizedBox(height: UniSizes.spaceBtwSections),
            UniSectionHeading(
              title: "Contact us",
              showActionButton: false,
            ),
            SizedBox(height: UniSizes.spaceBtwItems),
            SizedBox(height: UniSizes.spaceBtwItems),
            HelpOptions(
              title: "WhatsApp",
              subTitle: "chat us (020 745 4425) on WhatsApp",
              icon: Icons.message,
            ),
            SizedBox(height: UniSizes.spaceBtwItems),
            HelpOptions(
              title: "Call",
              subTitle: "Call our team (020 745 4425)",
              icon: Icons.call,
            ),
            SizedBox(height: UniSizes.spaceBtwItems),
            HelpOptions(
              title: "Email",
              subTitle: "Email us on (0322080142@htu.edu.gh)",
              icon: Icons.mail,
            )
          ],
        ),
      )),
    );
  }
}

class HelpOptions extends StatelessWidget {
  const HelpOptions({
    super.key,
    required this.title,
    required this.subTitle,
    this.onTap,
    required this.icon,
  });

  final String title, subTitle;
  final void Function()? onTap;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(UniSizes.md),
        decoration: BoxDecoration(
            color: HelperFunctions.isDarkMode(context)
                ? UniColors.dark
                : UniColors.lightContainer,
            borderRadius: BorderRadius.circular(UniSizes.borderRadius)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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
                ),
              ],
            ),
            Icon(
              icon,
              color: HelperFunctions.isDarkMode(context)
                  ? UniColors.secondary
                  : UniColors.primary,
              size: 35,
            )
          ],
        ),
      ),
    );
  }
}
