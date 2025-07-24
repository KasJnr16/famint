import 'package:fanmint/common/color_extension.dart';
import 'package:fanmint/controllers/user/update_user_info_controller.dart';
import 'package:fanmint/utility/constants/sizes.dart';
import 'package:fanmint/utility/validators/validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ChangeAdditionInfo extends StatelessWidget {
  final String title;
  final String fieldName; // Field name to determine which field to update
  final TextEditingController textController;
  final String labelText; // Field-specific label

  const ChangeAdditionInfo({
    super.key,
    required this.title,
    required this.fieldName,
    required this.textController,
    required this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.primary,
        centerTitle: true,
        elevation: 0.1,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Image.asset("assets/img/black_white.png", width: 25),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: TColor.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(UniSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SubTitle
            Text(
              "Update your information. This is your personal information and will be needed for relevant pages.",
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: UniSizes.spaceBtwSections),

            // Form
            Form(
              key: UpdateUserInfoController.instance.updateUserInfoFormKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: textController,
                    validator: (value) =>
                        UniValidator.validateEmptyText(labelText, value),
                    decoration: InputDecoration(
                      labelText: labelText,
                      prefixIcon: const Icon(Iconsax.edit),
                    ),
                  ),
                  const SizedBox(height: UniSizes.spaceBtwInputFields),
                ],
              ),
            ),
            const SizedBox(height: UniSizes.spaceBtwSections),

            // Save Button
            ElevatedButton(
              onPressed: () => UpdateUserInfoController.instance.updateUserInfo(
                fieldName,
                textController,
              ),
              child: Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}
