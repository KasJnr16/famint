import 'package:fanmint/common/color_extension.dart';
import 'package:fanmint/common_widget/animation_loader.dart';
import 'package:fanmint/controllers/expense_controller.dart';
import 'package:fanmint/utility/constants/colors.dart';
import 'package:fanmint/utility/constants/sizes.dart';
import 'package:fanmint/utility/helpers/helper_functions.dart';
import 'package:fanmint/view/settings/settings_view.dart';
import 'package:fanmint/view/track_budgets/methods/show_bottom_sheet.dart';
import 'package:fanmint/view/track_budgets/widget/expense_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TrackExpenseView extends StatelessWidget {
  const TrackExpenseView({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunctions.isDarkMode(context);
    final controller = ExpenseController.instance;

    return Scaffold(
      backgroundColor: dark ? TColor.gray : UniColors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(UniSizes.defaultSpace),
          child: Column(children: [
            //Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Track Expenses",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                IconButton(
                    onPressed: () => Get.to(() => const SettingsView()),
                    icon: Icon(Icons.settings))
              ],
            ),

            //body
            SizedBox(height: UniSizes.spaceBtwSections),
            Obx(() {
              final expenses = controller.expensesList;
              if (expenses.isEmpty) {
                return UniAnimationLoaderWidget(
                  lottie: 'assets/lottie/empty_box.json',
                  text: "No transaction History",
                  showAction: true,
                  actionText: "Add some",
                  onActionPressed: () => showAddExpenseBottomSheet(context),
                );
              }

              return ListView.builder(
                itemCount: expenses.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return ExpenseCard(expense: expenses[index]);
                },
              );
            }),
          ]),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 100),
        // Adjust this value as needed
        child: FloatingActionButton(
          backgroundColor: HelperFunctions.isDarkMode(context)
              ? UniColors.secondary
              : UniColors.primary,
          onPressed: () => showAddExpenseBottomSheet(context),
          child: Text(
            "Add",
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .apply(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
