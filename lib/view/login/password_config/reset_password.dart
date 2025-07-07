import 'package:fanmint/controllers/login/forget_password_controller.dart';
import 'package:fanmint/utility/constants/image_strings.dart';
import 'package:fanmint/utility/constants/sizes.dart';
import 'package:fanmint/utility/constants/text_string.dart';
import 'package:fanmint/utility/helpers/helper_functions.dart';
import 'package:fanmint/view/login/sign_in_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key, required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    final controller = ForgetPasswordController.instance;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(CupertinoIcons.clear))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(UniSizes.defaultSpace),
        child: Column(
          children: [
            //image
            Image(
              image: const AssetImage(UniImages.sentEmail),
              width: HelperFunctions.screenWidth() * 0.6,
            ),

            const SizedBox(height: UniSizes.spaceBtwSections),

            //Texts
            Text(
              email,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: UniSizes.spaceBtwItems),
            Text(
              UniTexts.changeYourPasswordTitle,
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: UniSizes.spaceBtwItems),
            Text(
              UniTexts.changeYourPasswordSubTitle,
              style: Theme.of(context).textTheme.labelMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: UniSizes.spaceBtwSections),

            //Buttons
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () => Get.offAll(() => SignInView()),
                  child: const Text(UniTexts.uDone)),
            ),
            const SizedBox(height: UniSizes.spaceBtwItems),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                  onPressed: () => controller.resendPasswordResetEmail(email),
                  child: const Text(UniTexts.resendEmail)),
            ),
          ],
        ),
      ),
    );
  }
}
