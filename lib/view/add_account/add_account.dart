// GetX-based HomeView Refactor
import 'package:fanmint/common_widget/section_heading.dart';
import 'package:fanmint/controllers/account_controller.dart';
import 'package:fanmint/controllers/subcription_controller.dart';
import 'package:fanmint/utility/constants/sizes.dart';
import 'package:fanmint/view/add_account/widget/bank_cards_view.dart';
import 'package:fanmint/view/add_account/widget/momo_view.dart';
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
              Obx(() {
                final hasMomo = accountController.momoWallets.isNotEmpty;
                final hasCards = accountController.bankCards.isNotEmpty;

                if (!hasMomo && !hasCards) return const SizedBox.shrink();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const UniSectionHeading(
                        title: "Active Accounts", showActionButton: false),
                    const SizedBox(height: UniSizes.spaceBtwItems),
                    if (hasMomo)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: accountController.momoWallets.map((wallet) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: UniSizes.sm),
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: Icon(Iconsax.mobile),
                              title: Text("MoMo Wallet"),
                              subtitle: Text(wallet.phoneNumber),
                              trailing: Text(
                                "GHC ${wallet.amount.toStringAsFixed(2)}",
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    if (hasCards)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: accountController.bankCards.map((card) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: UniSizes.sm),
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: Icon(Iconsax.bank),
                              title: Text(
                                  "Card Ending ••••${card.cardNumber.substring(card.cardNumber.length - 4)}"),
                              subtitle: Text("Expires: ${card.expiryDate}"),
                              trailing: const Icon(Icons.credit_card),
                            ),
                          );
                        }).toList(),
                      ),
                    const SizedBox(height: UniSizes.spaceBtwSections),
                  ],
                );
              }),

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
                onTap: () => Get.to(() => const BankCardsView()),
                title: "Add Bank Cards",
                icon: Iconsax.bank,
                subTitle: "Track your card expense",
              ),
              const SizedBox(height: UniSizes.spaceBtwItems),

              const SizedBox(height: 110),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: Padding(
      //   padding: const EdgeInsets.all(UniSizes.defaultSpace),
      //   child: SizedBox(
      //     width: double.infinity,
      //     child: OutlinedButton(
      //         onPressed: () {}, child: Text("View Transaction History")),
      //   ),
      // ),
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
                    "Total Daily Payment",
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

class OptionCard extends StatelessWidget {
  const OptionCard({
    super.key,
    this.onTap,
    required this.title,
    required this.subTitle,
    required this.icon,
  });

  final void Function()? onTap;
  final String title, subTitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: UniColors.darkGrey),
            color: HelperFunctions.isDarkMode(context) ? UniColors.dark : null,
            borderRadius: BorderRadius.circular(UniSizes.borderRadius)),
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(UniSizes.md),
          child: Row(
            children: [
              Icon(icon),
              SizedBox(
                width: UniSizes.spaceBtwItems,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    subTitle,
                    style: Theme.of(context).textTheme.labelMedium,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
