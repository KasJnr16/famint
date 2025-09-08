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

class BankView extends StatelessWidget {
  const BankView({super.key});

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
                    "Add Bank Funds",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ],
              ),
              const SizedBox(height: UniSizes.spaceBtwSections),

              //options
              UniSectionHeading(title: "Bank Details", showActionButton: false),
              const SizedBox(height: UniSizes.spaceBtwSections),
              Form(
                key: accountController.registerAccountKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: accountController.accountName,
                      validator: (value) =>
                          UniValidator.validateUsername(value),
                      decoration: const InputDecoration(
                          labelText: "Account Name",
                          prefixIcon: Icon(Iconsax.user)),
                    ),
                    SizedBox(height: UniSizes.spaceBtwItems),
                    TextFormField(
                      controller: accountController.accountNumber,
                      keyboardType: TextInputType.number,
                      validator: (value) => UniValidator.validateEmptyText(
                          "Account Number", value),
                      decoration: const InputDecoration(
                          labelText: "Account Number",
                          prefixIcon: Icon(Icons.numbers)),
                    ),
                    SizedBox(height: UniSizes.spaceBtwItems),
                    TextFormField(
                      controller: accountController.bankCode,
                      keyboardType: TextInputType.number,
                      validator: (value) =>
                          UniValidator.validateEmptyText("Bank Code", value),
                      decoration: const InputDecoration(
                          labelText: "Bank Code",
                          prefixIcon: Icon(Icons.numbers)),
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
              onPressed: () => accountController.saveBank(),
              child: Text("Bind Bank")),
        ),
      ),
    );
  }
}
