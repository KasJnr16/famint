// GetX-based HomeView Refactor
import 'package:fanmint/common_widget/section_heading.dart';
import 'package:fanmint/controllers/account_controller.dart';
import 'package:fanmint/utility/constants/sizes.dart';
import 'package:fanmint/utility/validators/validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fanmint/common/color_extension.dart';
import 'package:fanmint/utility/constants/colors.dart';
import 'package:fanmint/utility/helpers/helper_functions.dart';
import 'package:iconsax/iconsax.dart';

class MomoView extends StatelessWidget {
  const MomoView({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunctions.isDarkMode(context);
    final accountController = AccountController.instance;

    return Scaffold(
      backgroundColor: dark ? TColor.gray : UniColors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(UniSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                    "Add Momo Wallet",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ],
              ),
              const SizedBox(height: UniSizes.spaceBtwSections),

              //options
              UniSectionHeading(
                  title: "Account Details", showActionButton: false),
              const SizedBox(height: UniSizes.spaceBtwSections),
              Form(
                key: accountController.registerAccountKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: accountController.phoneNumber,
                      validator: (value) =>
                          UniValidator.validatePhoneNumner(value),
                      decoration: const InputDecoration(
                          labelText: "Phone Number",
                          prefixIcon: Icon(Iconsax.call)),
                    ),
                    SizedBox(height: UniSizes.spaceBtwItems),
                    Obx(
                      () => DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: "Select Network",
                          prefixIcon: Icon(Icons.network_cell),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        value: accountController.selectedNetwork.value.isEmpty
                            ? null
                            : accountController.selectedNetwork.value,
                        items: accountController.accountTypes.map((type) {
                          return DropdownMenuItem<String>(
                            value: type,
                            child: Text(type),
                          );
                        }).toList(),
                        onChanged: (value) {
                          accountController.selectedNetwork.value = value ?? "";
                        },
                      ),
                    ),
                    SizedBox(height: UniSizes.spaceBtwItems),
                    TextFormField(
                      controller: accountController.amount,
                      validator: (value) =>
                          UniValidator.validateEmptyText(value, "Amount"),
                      decoration: const InputDecoration(
                          labelText: "Amount",
                          prefixIcon: Icon(Icons.currency_exchange)),
                    ),
                    SizedBox(height: UniSizes.spaceBtwItems),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(UniSizes.defaultSpace),
        child: SizedBox(
          width: double.infinity,
          child: OutlinedButton(
              onPressed: () => accountController.saveMomoWallet(),
              child: Text("Bind Momo Wallet")),
        ),
      ),
    );
  }
}
