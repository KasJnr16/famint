import 'package:fanmint/controllers/login/verify_email_controller.dart';
import 'package:fanmint/repositories/authentication/authentication_repository.dart';
import 'package:fanmint/utility/constants/sizes.dart';
import 'package:fanmint/utility/constants/text_string.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key, this.email});

  final String? email;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VerifyEmailController());
    return Scaffold(
      //This screen is always going to pop up if the user does not verify email
      //After account is created.

      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () => AuthenticationRepository.instance.logout(),
              icon: const Icon(CupertinoIcons.clear))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(UniSizes.defaultSpace),
          child: Column(
            children: [
              //Image
              // Image(
              //   image: const AssetImage(UniImages.sentEmail),
              //   width: HelperFunctions.screenWidth() * 0.6,
              // ),

              const SizedBox(height: UniSizes.spaceBtwSections),

              //Title and SubTitles
              Text(
                UniTexts.confirmEmail,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: UniSizes.spaceBtwItems),
              Text(
                email ?? "",
                style: Theme.of(context).textTheme.labelLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: UniSizes.spaceBtwItems),
              Text(
                UniTexts.confirmEmailSubTitle,
                style: Theme.of(context).textTheme.labelMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: UniSizes.spaceBtwSections),

              //Buttons
              SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.065,
                child: ElevatedButton(
                  onPressed: () {
                    controller.checkEmailVerificationStatus();
                  },
                  child: Text(UniTexts.uContinue),
                ),
              ),

              const SizedBox(height: UniSizes.spaceBtwItems),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                    onPressed: () => controller.sendEmailVerification(),
                    child: const Text(UniTexts.resendEmail)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
