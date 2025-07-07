import 'package:fanmint/common_widget/appbar.dart';
import 'package:fanmint/controllers/user/user_controller.dart';
import 'package:fanmint/utility/constants/sizes.dart';
import 'package:fanmint/utility/constants/text_string.dart';
import 'package:fanmint/utility/validators/validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
class ReAuthLoginForm extends StatelessWidget {
  const ReAuthLoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserController());
    return Scaffold(
      appBar: UniAppBar(
        showBackArrow: true,
        title: Text("Re-Authenticate User",
            style: Theme.of(context).textTheme.headlineSmall),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(UniSizes.defaultSpace),
          child: Form(
              key: controller.reAuthFormKey,
              child: Column(
                children: [
                  //Email
                  TextFormField(
                    controller: controller.verifyEmail,
                    validator: (value) => UniValidator.validateEmail(value),
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Iconsax.direct_right),
                        labelText: UniTexts.email),
                  ),
                  const SizedBox(height: UniSizes.spaceBtwInputFields),

                  //Password
                  Obx(
                    () => TextFormField(
                      obscureText: controller.hidePassword.value,
                      validator: (value) =>
                          UniValidator.validateEmptyText("Password", value),
                      controller: controller.verifyPassword,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: controller.hidePassword.value
                                ? const Icon(Iconsax.eye_slash)
                                : const Icon(Iconsax.eye),
                            onPressed: () => controller.hidePassword.value =
                                !controller.hidePassword.value,
                          ),
                          labelText: UniTexts.password,
                          prefixIcon: const Icon(Iconsax.password_check)),
                    ),
                  ),
                  const SizedBox(height: UniSizes.spaceBtwInputFields),

                  //Verify Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () =>
                            controller.reAuthenticateEmailAndPasswordUser(),
                        child: const Text("Verify")),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
