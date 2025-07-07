import 'package:fanmint/common_widget/spacing_styles.dart';
import 'package:fanmint/utility/constants/sizes.dart';
import 'package:fanmint/utility/constants/text_string.dart';
import 'package:flutter/material.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen(
      {super.key,
      required this.image,
      required this.title,
      required this.subtitle,
      this.onPressed});

  final String image, title, subtitle;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: UniSpacingStyle.paddingWithAppBarHeight,
          child: Column(
            children: [
              //image
              // Image(
              //   image: AssetImage(image),
              //   width: HelperFunctions.screenWidth() * 0.6,
              //   height: HelperFunctions.screenHeight() * 0.4,
              // ),

              const SizedBox(height: UniSizes.spaceBtwSections),

              //Title $ SubTitles
              Text(
                title,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: UniSizes.spaceBtwItems),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.labelMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: UniSizes.spaceBtwSections),

              //Buttons
              SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.07,
                child: ElevatedButton(
                    onPressed: onPressed,
                    child: const Text(UniTexts.uContinue)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
