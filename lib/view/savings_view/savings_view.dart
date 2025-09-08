import 'package:fanmint/common_widget/animation_loader.dart';
import 'package:fanmint/controllers/savings_controller.dart';
import 'package:fanmint/models/savings_account_model.dart';
import 'package:fanmint/utility/constants/colors.dart';
import 'package:fanmint/utility/constants/sizes.dart';
import 'package:fanmint/utility/helpers/helper_functions.dart';
import 'package:fanmint/view/savings_view/savings_account_view.dart';
import 'package:fanmint/view/savings_view/widget/pop_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SavingsView extends StatelessWidget {
  const SavingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = SavingsController.instance;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(UniSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () => Get.back(),
                  color: HelperFunctions.isDarkMode(context)
                      ? UniColors.secondary
                      : UniColors.primary,
                  icon: const Icon(Icons.arrow_back),
                ),
                Text(
                  "Savings",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),
            const SizedBox(height: UniSizes.spaceBtwSections),

            /// Savings List
            Expanded(
              child: Obx(() {
                if (controller.savingsAccountList.isEmpty) {
                  return UniAnimationLoaderWidget(
                    lottie: "assets/lottie/empty_box.json",
                    text: "You have no savings account",
                  );
                }

                return ListView.separated(
                  itemCount: controller.savingsAccountList.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: UniSizes.spaceBtwItems),
                  itemBuilder: (context, index) {
                    final SavingsAccountModel account =
                        controller.savingsAccountList[index];
                    return Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(UniSizes.cardRadiusSm),
                        color: HelperFunctions.isDarkMode(context)
                            ? UniColors.dark
                            : UniColors.lightContainer,
                      ),
                      child: ListTile(
                        title: Text(
                          account.accountName,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        subtitle: Text(account.reason ?? "No specific reason"),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "Balance: ${account.balance?.toStringAsFixed(2) ?? '---'}",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                        onTap: () {
                          Get.to(
                              () => SavingsAccountView(accountId: account.id!));
                        },
                      ),
                    );
                  },
                );
              }),
            ),

            /// Add Savings Account Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => showAddSavingsForm(context, controller),
                icon: const Icon(Icons.add),
                label: const Text("Add Savings Account"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
