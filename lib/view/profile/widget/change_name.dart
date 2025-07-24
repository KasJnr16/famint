import 'package:fanmint/common/color_extension.dart';
import 'package:fanmint/controllers/user/update_name_controller.dart';
import 'package:fanmint/utility/constants/sizes.dart';
import 'package:fanmint/utility/constants/text_string.dart';
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
      //heading
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.1,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Image.asset("assets/img/back.png",
              width: 25, height: 25, color: TColor.gray30),
        ),
        title: Text(
          "Change Name",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(UniSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          //SubTitle
          children: [
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
                      labelText: UniTexts.firstName,
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
