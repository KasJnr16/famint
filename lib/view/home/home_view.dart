// GetX-based HomeView Refactor
import 'package:fanmint/controllers/subcription_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fanmint/common/color_extension.dart';
import 'package:fanmint/utility/constants/colors.dart';
import 'package:fanmint/utility/helpers/helper_functions.dart';
import '../../common_widget/custom_arc_painter.dart';
import '../../common_widget/segment_button.dart';
import '../../common_widget/status_button.dart';
import '../../common_widget/subscription_home_row.dart';
import '../../common_widget/upcoming_bill_row.dart';
import '../settings/settings_view.dart';
import '../subscription_info/subscription_info_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SubscriptionController());
    var media = MediaQuery.sizeOf(context);
    final dark = HelperFunctions.isDarkMode(context);

    return Scaffold(
      backgroundColor: dark ? TColor.gray : UniColors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context, media, dark),
            Obx(() => _buildToggleTabs(controller, dark)),
            Obx(() => !controller.isSpentToday.value
                ? _buildConfirmedExpenses(controller)
                : _buildPlannedExpenses(controller)),
            const SizedBox(height: 110),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Size media, bool dark) {
    final controller = SubscriptionController.instance;
    return Container(
      height: media.width * 1.1,
      decoration: BoxDecoration(
        color: dark ? TColor.gray70.withOpacity(0.5) : UniColors.light,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            "assets/img/home_bg.png",
            color: UniColors.dark.withOpacity(0.5),
          ),
          Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                padding: EdgeInsets.only(bottom: media.width * 0.05),
                width: media.width * 0.72,
                height: media.width * 0.72,
                child: CustomPaint(painter: CustomArcPainter(end: 220)),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Row(
                  children: [
                    const Spacer(),
                    IconButton(
                      onPressed: () => Get.to(() => const SettingsView()),
                      icon: Image.asset(
                        "assets/img/settings.png",
                        width: 25,
                        height: 25,
                        color: dark ? TColor.white : UniColors.dark,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: media.width * 0.02),
              Image.asset(
                "assets/img/app_logo_no_background.png",
                color: dark ? null : UniColors.primary,
                width: media.width * 0.1,
                fit: BoxFit.contain,
              ),
              SizedBox(height: media.width * 0.07),

              //money
              Obx(
                () => Text(
                  "GHC ${controller.calculatedBudget.value.toStringAsFixed(2)}",
                  style: const TextStyle(
                      fontSize: 40, fontWeight: FontWeight.w700),
                ),
              ),
              SizedBox(height: media.width * 0.055),

              //button
              const Text("Monthly Budget",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              SizedBox(height: media.width * 0.07),
              InkWell(
                onTap: () {
                  Get.defaultDialog(
                    title: "Set Monthly Budget",
                    content: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: controller.setMontlyBudget,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            labelText: "Enter budget (GHC)"),
                      ),
                    ),
                    confirm: ElevatedButton(
                        onPressed: () {
                          controller.setBudget();
                        },
                        child: Text("Confrim")),
                    cancel: OutlinedButton(
                        onPressed: () => Get.back(), child: Text("Cancel")),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: dark
                            ? TColor.border.withOpacity(0.15)
                            : UniColors.light),
                    color:
                        dark ? TColor.gray60.withOpacity(0.3) : UniColors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text("Set Your Budget",
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Spacer(),
                Row(
                  children: [
                    Expanded(
                      child: StatusButton(
                        title: "Active",
                        value: controller.plannedExpensesList.length.toString(),
                        statusColor: TColor.secondary,
                        onPressed: () {},
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: StatusButton(
                        title: "Highest Expense",
                        value: controller.highestExpense.value.toString(),
                        statusColor: TColor.primary10,
                        onPressed: () {},
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: StatusButton(
                        title: "Lowest subs",
                        value: controller.lowestExpense.value.toString(),
                        statusColor: TColor.secondaryG,
                        onPressed: () {},
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildToggleTabs(SubscriptionController controller, bool dark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      height: 50,
      decoration: BoxDecoration(
        color: dark ? Colors.black : UniColors.lightContainer,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Expanded(
            child: SegmentButton(
              title: "Planned Expenses",
              isActive: controller.isSpentToday.value,
              onPressed: () => controller.isSpentToday.value = true,
            ),
          ),
          Expanded(
            child: SegmentButton(
              title: "Confirmed Expenses",
              isActive: !controller.isSpentToday.value,
              onPressed: () => controller.isSpentToday.value = false,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmedExpenses(SubscriptionController controller) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: controller.confirmedExpensesList.length,
      itemBuilder: (context, index) {
        final item = controller.confirmedExpensesList[index];
        return ConfirmedExpensesRow(
          item: item,
          onPressed: () => Get.to(() => SubscriptionInfoView(item: item)),
        );
      },
    );
  }

  Widget _buildPlannedExpenses(SubscriptionController controller) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: controller.plannedExpensesList.length,
      itemBuilder: (context, index) {
        final item = controller.plannedExpensesList[index];
        return PlannedExpensesRow(
          item: item,
          onPressed: () {},
        );
      },
    );
  }
}
