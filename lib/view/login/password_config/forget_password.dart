import 'package:fanmint/common_widget/appbar.dart';
import 'package:fanmint/controllers/login/forget_password_controller.dart';
import 'package:fanmint/utility/constants/sizes.dart';
import 'package:fanmint/utility/constants/text_string.dart';
import 'package:fanmint/utility/validators/validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ForgetPassword extends StatelessWidget {
  const ForgetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgetPasswordController());

    return Scaffold(
      appBar: UniAppBar(
        showBackArrow: true,
        padding: EdgeInsets.zero,
      ),
      body: Padding(
        padding: const EdgeInsets.all(UniSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Headin
            Text(UniTexts.forgetPasswordTitle,
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: UniSizes.spaceBtwItems),
            Text(UniTexts.forgetPasswordSubTitle,
                style: Theme.of(context).textTheme.labelMedium),

            const SizedBox(height: UniSizes.spaceBtwSections * 2),

            //text field
            Form(
              key: controller.forgetPasswordFormKey,
              child: TextFormField(
                controller: controller.email,
                validator: UniValidator.validateEmail,
                decoration: const InputDecoration(
                    labelText: UniTexts.email,
                    prefixIcon: Icon(Iconsax.direct_right)),
              ),
            ),

            const SizedBox(height: UniSizes.spaceBtwSections),

            //Submit Button
            SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.07,
                child: ElevatedButton(
                    onPressed: () => controller.sendPasswordResetEmail(),
                    child: const Text(UniTexts.submit)))
          ],
        ),
      ),
    );
  }
}
