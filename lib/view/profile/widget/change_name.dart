import 'package:fanmint/controllers/user/update_name_controller.dart';
import 'package:fanmint/utility/constants/colors.dart';
import 'package:fanmint/utility/constants/sizes.dart';
import 'package:fanmint/utility/constants/text_string.dart';
import 'package:fanmint/utility/helpers/helper_functions.dart';
import 'package:fanmint/utility/validators/validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ChangeNameScreen extends StatelessWidget {
  const ChangeNameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UpdateNameController());
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(UniSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          //SubTitle
          children: [
            //header
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                    onPressed: () => Get.back(),
                    color: HelperFunctions.isDarkMode(context)
                        ? UniColors.secondary
                        : UniColors.primary,
                    icon: Icon(Icons.arrow_back)),
                Text(
                  "Change Name",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),
            const SizedBox(height: UniSizes.spaceBtwSections),
            Text(
              "Use real name for easy verification. This name will appear on relevant pages.",
              style: Theme.of(context).textTheme.labelLarge,
            ),

            const SizedBox(height: UniSizes.spaceBtwSections),

            //TextField
            Form(
              key: controller.updateUserNameFormKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: controller.firstName,
                    validator: (value) =>
                        UniValidator.validateEmptyText("First name", value),
                    expands: false,
                    decoration: const InputDecoration(
                      labelText: UniTexts.firstName,
                      prefixIcon: Icon(Iconsax.user),
                    ),
                  ),
                  const SizedBox(height: UniSizes.spaceBtwInputFields),
                  TextFormField(
                    controller: controller.lastName,
                    validator: (value) =>
                        UniValidator.validateEmptyText("Last name", value),
                    expands: false,
                    decoration: const InputDecoration(
                      labelText: UniTexts.lastName,
                      prefixIcon: Icon(Iconsax.user),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: UniSizes.spaceBtwSections),

            //Save Button
            ElevatedButton(
              onPressed: () => controller.updateUserName(),
              child: Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}
