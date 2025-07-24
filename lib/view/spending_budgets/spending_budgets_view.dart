import 'package:fanmint/common/color_extension.dart';
import 'package:fanmint/common_widget/budgets_row.dart';
import 'package:fanmint/common_widget/custom_arc_180_painter.dart';
import 'package:fanmint/controllers/budget_controller.dart';
import 'package:fanmint/controllers/subcription_controller.dart';
import 'package:fanmint/utility/constants/colors.dart';
import 'package:fanmint/utility/helpers/helper_functions.dart';
import 'package:fanmint/view/settings/settings_view.dart';
import 'package:fanmint/view/spending_budgets/add_new_expense.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SpendingBudgetsView extends StatelessWidget {
  const SpendingBudgetsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BudgetController());
    var media = MediaQuery.sizeOf(context);
    final dark = HelperFunctions.isDarkMode(context);
    final subController = SubscriptionController.instance;

    return Scaffold(
      backgroundColor: dark ? TColor.gray : UniColors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 35, right: 10),
              child: Row(
                children: [
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      Get.to(() => const SettingsView());
                    },
                    icon: Image.asset("assets/img/settings.png",
                        width: 25,
                        height: 25,
                        color: dark ? UniColors.white : UniColors.dark),
                  )
                ],
              ),
            ),
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                SizedBox(
                  width: media.width * 0.5,
                  height: media.width * 0.30,
                  child: CustomPaint(
                    painter: CustomArc180Painter(
                      drwArcs: controller.arcValues,
                      end: 50,
                      width: 12,
                      bgWidth: 8,
                    ),
                  ),
                ),

                //monthly budget over spent
                Obx(() {
                  final spent = subController.monthlySpent.value;
                  final budget = subController.calculatedBudget.value;
                  return Column(
                    children: [
                      Text(
                        "GHC ${spent.toStringAsFixed(2)}",
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w700),
                      ),
                      Text(
                        "of GHC ${budget.toStringAsFixed(2)} budget",
                        style: TextStyle(
                          color: TColor.gray30,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  );
                })
              ],
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {},
                child: Container(
                  height: 64,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: dark
                          ? TColor.border.withOpacity(0.1)
                          : UniColors.light,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      subController.monthlySpent.value <
                              subController.calculatedBudget.value
                          ? Text(
                              "Your budgets are on track👍",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          : Text(
                              "Your budgets are not on track 😢",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                    ],
                  ),
                ),
              ),
            ),
            Obx(
              () => ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: controller.expensesList.length,
                itemBuilder: (context, index) {
                  final bObj = controller.expensesList[index];
                  return BudgetsRow(
                    budget: bObj,
                    onPressed: () {},
                  );
                },
              ),
            ),
            AddNewExpenseButton(
                controller: controller,
                subController: subController,
                dark: dark),
            const SizedBox(height: 110),
          ],
        ),
      ),
    );
  }
}
