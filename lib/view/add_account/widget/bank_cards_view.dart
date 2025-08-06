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

class BankCardsView extends StatelessWidget {
  const BankCardsView({super.key});

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
                    "Add Bank Cards",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ],
              ),
              const SizedBox(height: UniSizes.spaceBtwSections),

              //options
              UniSectionHeading(title: "Card Details", showActionButton: false),
              const SizedBox(height: UniSizes.spaceBtwSections),
              Form(
                key: accountController.registerAccountKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: accountController.cardName,
                      validator: (value) =>
                          UniValidator.validateUsername(value),
                      decoration: const InputDecoration(
                          labelText: "Card Name",
                          prefixIcon: Icon(Iconsax.user)),
                    ),
                    SizedBox(height: UniSizes.spaceBtwItems),
                    TextFormField(
                      controller: accountController.cardNumber,
                      keyboardType: TextInputType.number,
                      validator: (value) =>
                          UniValidator.validateEmptyText("Card Number", value),
                      decoration: const InputDecoration(
                          labelText: "Card Number",
                          prefixIcon: Icon(Icons.numbers)),
                    ),
                    SizedBox(height: UniSizes.spaceBtwItems),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: accountController.cardCvc,
                            keyboardType: TextInputType.number,
                            validator: (value) =>
                                UniValidator.validateEmptyText("CVC", value),
                            decoration: const InputDecoration(
                                labelText: "CVC", prefixIcon: Icon(Icons.code)),
                          ),
                        ),
                        SizedBox(width: UniSizes.spaceBtwItems),
                        Expanded(
                          child: TextFormField(
                            controller: accountController.cardDate,
                            keyboardType: TextInputType.datetime,
                            validator: (value) =>
                                UniValidator.validateEmptyText("Date", value),
                            decoration: const InputDecoration(
                                labelText: "Date",
                                prefixIcon: Icon(Icons.date_range)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: UniSizes.spaceBtwItems),

              const SizedBox(height: 110),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(UniSizes.defaultSpace),
        child: SizedBox(
          width: double.infinity,
          child: OutlinedButton(
              onPressed: () => accountController.saveBankCard(),
              child: Text("Bind Card")),
        ),
      ),
    );
  }
}
