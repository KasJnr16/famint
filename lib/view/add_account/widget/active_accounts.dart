import 'package:fanmint/common_widget/section_heading.dart';
import 'package:fanmint/controllers/account_controller.dart';
import 'package:fanmint/utility/constants/sizes.dart';
import 'package:fanmint/view/top_up/top_up.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ActiveAccountsList extends StatelessWidget {
  const ActiveAccountsList({
    super.key,
    required this.accountController,
  });

  final AccountController accountController;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final hasMomo = accountController.momoWallets.isNotEmpty;
      final hasBanks = accountController.banks.isNotEmpty;

      if (!hasMomo && !hasBanks) return const SizedBox.shrink();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const UniSectionHeading(
              title: "Active Accounts", showActionButton: false),
          const SizedBox(height: UniSizes.spaceBtwItems),

          // momo
          if (hasMomo)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: accountController.momoWallets.map((wallet) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: UniSizes.sm),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: UniSizes.spaceBtwItems),
                    leading: Icon(Iconsax.mobile),
                    title: Text("MoMo Wallet"),
                    subtitle: Text(wallet.phoneNumber),
                    trailing: Text(
                      "",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    onTap: () {
                      Get.to(() => TopUpView(
                            accountTitle: "MoMo Wallet",
                            accountId: wallet.phoneNumber,
                            onPressed: () =>
                                accountController.updateAccount(wallet),
                          ));
                    },
                  ),
                );
              }).toList(),
            ),

          // bank
          if (hasBanks)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: accountController.banks.map((bank) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: UniSizes.sm),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: UniSizes.spaceBtwItems),
                    leading: Icon(Iconsax.bank),
                    title: Text(
                        "Bank Ending ••••${bank.accountName.substring(bank.accountName.length - 4)}"),
                    subtitle: Text(""),
                    trailing: const Icon(Icons.credit_card),
                    onTap: () {
                      Get.to(() => TopUpView(
                            accountTitle: "Bank Account",
                            accountId: bank.accountNumber,
                            onPressed: () =>
                                accountController.updateAccount(bank),
                          ));
                    },
                  ),
                );
              }).toList(),
            ),
          const SizedBox(height: UniSizes.spaceBtwSections),
        ],
      );
    });
  }
}
