import 'package:fanmint/common_widget/section_heading.dart';
import 'package:fanmint/controllers/savings_controller.dart';
import 'package:fanmint/utility/constants/colors.dart';
import 'package:fanmint/utility/constants/sizes.dart';
import 'package:fanmint/utility/helpers/helper_functions.dart';
import 'package:fanmint/view/savings_view/widget/chart_widget.dart';
import 'package:fanmint/view/savings_view/widget/savings_transaction_form.dart';
import 'package:fanmint/view/savings_view/widget/transaction_history.dart';
import 'package:fanmint/view/top_up/top_up.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SavingsAccountView extends StatelessWidget {
  const SavingsAccountView({super.key, required this.accountId});

  final String accountId;

  @override
  Widget build(BuildContext context) {
    final savingsController = SavingsController.instance;
    final bool dark = HelperFunctions.isDarkMode(context);

    return Obx(() {
      final account = savingsController.savingsAccountList
          .firstWhere((a) => a.id == accountId);

      return Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(UniSizes.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Get.back(),
                      color: dark ? UniColors.secondary : UniColors.primary,
                      icon: const Icon(Icons.arrow_back),
                    ),
                    Text(
                      account.accountName,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ],
                ),
                const SizedBox(height: UniSizes.spaceBtwSections),

                // Chart
                SavingsChartWidget(account: account),
                const SizedBox(height: UniSizes.spaceBtwItems),

                // Total Amount
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(UniSizes.defaultSpace),
                  decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(UniSizes.cardRadiusMd),
                      color: HelperFunctions.isDarkMode(context)
                          ? UniColors.dark
                          : UniColors.lightContainer),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Total Balance: GHC${account.balance?.toStringAsFixed(2)}",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(height: UniSizes.spaceBtwItems),
                      Text(
                        account.reason ?? "Not specified",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      SizedBox(height: UniSizes.spaceBtwItems),
                      Text(
                        "Target Amount: GHC${account.targetAmount?.toStringAsFixed(2)}",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: UniSizes.spaceBtwSections),

                // Transactions
                UniSectionHeading(
                  title: "Recent Transactions",
                  showActionButton: false,
                ),
                const SizedBox(height: UniSizes.spaceBtwItems / 2),
                TransactionHistory(account: account),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(UniSizes.defaultSpace),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Get.to(() => TopUpView(
                          pageTitle: "Top Up",
                          widget: SavingsTransactionForm(
                            isTopUp: true,
                            account: account,
                          ),
                        ));
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("Top Up"),
                ),
              ),
              const SizedBox(width: UniSizes.spaceBtwItems),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Get.to(() => TopUpView(
                          pageTitle: "Withdraw",
                          widget: SavingsTransactionForm(
                            isTopUp: false,
                            account: account,
                          ),
                        ));
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(UniColors.error),
                  ),
                  icon: const Icon(Icons.remove),
                  label: const Text("Withdraw"),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
