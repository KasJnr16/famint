// GetX-based HomeView Refactor
import 'package:fanmint/common_widget/section_heading.dart';
import 'package:fanmint/controllers/account_controller.dart';
import 'package:fanmint/controllers/subcription_controller.dart';
import 'package:fanmint/utility/constants/sizes.dart';
import 'package:fanmint/view/add_account/widget/active_accounts.dart';
import 'package:fanmint/view/add_account/widget/bank_view.dart';
import 'package:fanmint/view/add_account/widget/momo_view.dart';
import 'package:fanmint/view/add_account/widget/option_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fanmint/common/color_extension.dart';
import 'package:fanmint/utility/constants/colors.dart';
import 'package:fanmint/utility/helpers/helper_functions.dart';
import 'package:iconsax/iconsax.dart';

class AddAccount extends StatelessWidget {
  const AddAccount({super.key});

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
                    "Add Account",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ],
              ),
              const SizedBox(height: UniSizes.spaceBtwSections),

              //information
              _buildHeader(context),
              const SizedBox(height: UniSizes.spaceBtwSections),

              //accounts
              ActiveAccountsList(accountController: accountController),

              //options
              UniSectionHeading(title: "Options", showActionButton: false),
              const SizedBox(height: UniSizes.spaceBtwSections),

              //cards
              OptionCard(
                onTap: () => Get.to(() => const MomoView()),
                title: "Add Momo Wallet",
                icon: Iconsax.mobile,
                subTitle: "Track your momo expense",
              ),
              const SizedBox(height: UniSizes.spaceBtwItems),
              OptionCard(
                onTap: () => Get.to(() => const BankView()),
                title: "Add Bank",
                icon: Iconsax.bank,
                subTitle: "Track your card expense",
              ),
              const SizedBox(height: UniSizes.spaceBtwItems),

              const SizedBox(height: 110),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final controller = SubscriptionController.instance;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(UniSizes.cardRadiusSm),
          color: HelperFunctions.isDarkMode(context)
              ? UniColors.dark
              : UniColors.light,
        ),
        child: Padding(
          padding: const EdgeInsets.all(UniSizes.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Current Budget",
                style: Theme.of(context).textTheme.titleSmall!,
              ),
              const SizedBox(height: UniSizes.spaceBtwSections),

              // --- Deatils ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total Amount",
                    style: Theme.of(context).textTheme.labelLarge!,
                  ),
                  Obx(
                    () => Text(
                      "GHC ${controller.totalBalance.value.toStringAsFixed(2)}",
                      style: Theme.of(context).textTheme.bodyLarge!,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total Expenses",
                    style: Theme.of(context).textTheme.labelLarge!,
                  ),
                  Obx(
                    () => Text(
                      "GHC ${controller.totalUsedBalance.value.toStringAsFixed(2)}",
                      style: Theme.of(context).textTheme.bodyLarge!,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Amount left",
                    style: Theme.of(context).textTheme.labelLarge!,
                  ),
                  Text(
                    "GHC ${controller.calculatedBalance.toStringAsFixed(2)}",
                    style: Theme.of(context).textTheme.bodyLarge!,
                  ),
                ],
              ),

              const SizedBox(height: UniSizes.spaceBtwSections),
            ],
          ),
        ),
      )
    ]);
  }
}
