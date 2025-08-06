// GetX-based HomeView Refactor
import 'package:fanmint/common_widget/shimmer.dart';
import 'package:fanmint/controllers/subcription_controller.dart';
import 'package:fanmint/controllers/user/user_controller.dart';
import 'package:fanmint/utility/constants/sizes.dart';
import 'package:fanmint/view/settings/settings_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fanmint/common/color_extension.dart';
import 'package:fanmint/utility/constants/colors.dart';
import 'package:fanmint/utility/helpers/helper_functions.dart';
import 'package:iconsax/iconsax.dart';
import '../../common_widget/segment_button.dart';
import '../../common_widget/subscription_home_row.dart';
import '../../common_widget/upcoming_bill_row.dart';
import '../subscription_info/subscription_info_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SubscriptionController());
    final userController = UserController.instance;
    final dark = HelperFunctions.isDarkMode(context);

    return Scaffold(
      backgroundColor: dark ? TColor.gray : UniColors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(UniSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Obx(() => userController.profileLoading.value
                          ? UniShimmerEffect(width: 60, height: 20)
                          : Text(
                              "Hi, ${userController.currentUser.value.fullname}",
                              style: Theme.of(context).textTheme.titleLarge,
                            )),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.notifications_none)),
                      IconButton(
                          onPressed: () => Get.to(() => const SettingsView()),
                          icon: Icon(Icons.settings_outlined)),
                    ],
                  )
                ],
              ),
              const SizedBox(height: UniSizes.spaceBtwSections),
              _buildHeader(context),
              Obx(() => _buildToggleTabs(controller, dark)),
              Obx(() => !controller.isSpentToday.value
                  ? _buildConfirmedExpenses(controller)
                  : _buildPlannedExpenses(controller)),
              const SizedBox(height: 110),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final controller = SubscriptionController.instance;
    double totalBudget = 3000; // Example total budget
    double totalUsed = 1500; // Example used
    double progress = totalUsed / totalBudget;

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
                "On Progress",
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .apply(color: UniColors.primary),
              ),
              const SizedBox(height: UniSizes.spaceBtwSections),

              // --- Progress Bar ---
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progress.clamp(0.0, 1.0),
                  minHeight: 10,
                  backgroundColor: Colors.grey.shade300,
                  valueColor: AlwaysStoppedAnimation<Color>(UniColors.primary),
                ),
              ),

              const SizedBox(height: UniSizes.spaceBtwSections),

              // --- MONEY SECTION ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // TOTAL USED
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "TOTAL USED",
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      Text(
                        "GHC ${totalUsed.toStringAsFixed(2)}",
                        style: Theme.of(context).textTheme.bodyLarge,
                      )
                    ],
                  ),
                  Icon(Iconsax.eye),
                  // BALANCE
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "BALANCE",
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      Text(
                        "GHC ${(totalBudget - totalUsed).toStringAsFixed(2)}",
                        style: Theme.of(context).textTheme.bodyLarge,
                      )
                    ],
                  ),
                ],
              ),
              const SizedBox(height: UniSizes.spaceBtwSections),

              // --- Button SECTION ---
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text("Add Budget"),
                ),
              )
            ],
          ),
        ),
      )
    ]);
  }

  Widget _buildToggleTabs(SubscriptionController controller, bool dark) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      height: 50,
      decoration: BoxDecoration(
        color: dark ? UniColors.dark : UniColors.light,
        borderRadius: BorderRadius.circular(UniSizes.cardRadiusSm),
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
          onPressed: () => Get.to(() => SubscriptionInfoView(budget: item)),
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
