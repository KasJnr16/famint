// GetX-based HomeView Refactor
import 'package:fanmint/common_widget/animation_loader.dart';
import 'package:fanmint/common_widget/section_heading.dart';
import 'package:fanmint/common_widget/shimmer.dart';
import 'package:fanmint/controllers/subcription_controller.dart';
import 'package:fanmint/controllers/user/user_controller.dart';
import 'package:fanmint/utility/constants/sizes.dart';
import 'package:fanmint/view/add_account/add_account.dart';
import 'package:fanmint/view/home/widget/savings_card.dart';
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
import 'package:intl/intl.dart';

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
                              style: Theme.of(context).textTheme.headlineSmall,
                            )),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () => Get.to(() => const SettingsView()),
                          icon: Icon(Icons.settings_outlined)),
                    ],
                  )
                ],
              ),
              const SizedBox(height: UniSizes.spaceBtwSections),
              SavingsCard(),
              const SizedBox(height: UniSizes.spaceBtwItems),
              UniSectionHeading(
                title: "Track Expenses",
                showActionButton: false,
              ),
              const SizedBox(height: UniSizes.spaceBtwItems),
              _buildExpenseTracker(context),
              const SizedBox(height: UniSizes.spaceBtwItems),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.to(() => const AddAccount()),
                  child: Text("Add Account"),
                ),
              ),
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

  Widget _buildExpenseTracker(BuildContext context) {
    final controller = SubscriptionController.instance;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(UniSizes.cardRadiusSm),
          color: HelperFunctions.isDarkMode(context)
              ? UniColors.dark
              : UniColors.lightContainer,
        ),
        child: Padding(
          padding: const EdgeInsets.all(UniSizes.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() {
                if (controller.totalBalance.value >
                    controller.totalUsedBalance.value) {
                  return Text(
                    "On Progress",
                    style: Theme.of(context).textTheme.titleMedium!.apply(
                          color: HelperFunctions.isDarkMode(context)
                              ? UniColors.secondary
                              : UniColors.primary,
                        ),
                  );
                } else {
                  return Text(
                    "No Progress",
                    style: Theme.of(context).textTheme.titleMedium!.apply(
                          color: UniColors.error,
                        ),
                  );
                }
              }),
              const SizedBox(height: UniSizes.spaceBtwItems),

              // --- Progress Bar ---
              Obx(
                () => ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: (controller.totalUsedBalance.value /
                            controller.totalBalance.value)
                        .clamp(0.0, 1.0),
                    minHeight: 10,
                    backgroundColor: Colors.grey.shade300,
                    valueColor: AlwaysStoppedAnimation<Color>(
                        HelperFunctions.isDarkMode(context)
                            ? UniColors.secondary
                            : UniColors.primary),
                  ),
                ),
              ),

              const SizedBox(height: UniSizes.spaceBtwItems),

              // --- MONEY SECTION ---
              Obx(() {
                final hidden = controller.isHidden.value;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // TOTAL USED
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "TOTAL USED",
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          Text(
                            hidden
                                ? "****"
                                : "GHC ${controller.totalUsedBalance.toStringAsFixed(2)}",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ),

                    // Eye icon to toggle
                    Expanded(
                      child: IconButton(
                        icon: Icon(hidden ? Iconsax.eye_slash : Iconsax.eye),
                        onPressed: () => controller.isHidden.toggle(),
                      ),
                    ),

                    // BALANCE
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "TOTAL REMAINING",
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          Text(
                            hidden
                                ? "****"
                                : "GHC ${controller.calculatedBalance.toStringAsFixed(2)}",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
      SizedBox(
        height: UniSizes.spaceBtwItems,
      ),
      Text(
        getFormattedDateTime(),
        style: Theme.of(context).textTheme.labelLarge,
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
    return Obx(() {
      if (controller.confirmedExpensesList.isEmpty) {
        return UniAnimationLoaderWidget(
          lottie: 'assets/lottie/no_history.json',
          text: "No expenses",
          showAction: false,
          width: MediaQuery.of(Get.context!).size.width * 0.4,
        );
      }

      return ListView.builder(
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
    });
  }

  Widget _buildPlannedExpenses(SubscriptionController controller) {
    return Obx(() {
      if (controller.plannedExpensesList.isEmpty) {
        return UniAnimationLoaderWidget(
          lottie: 'assets/lottie/no_history.json',
          text: "No expenses",
          showAction: false,
          width: MediaQuery.of(Get.context!).size.width * 0.4,
        );
      }
      return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: controller.plannedExpensesList.length,
        itemBuilder: (context, index) {
          final budget = controller.plannedExpensesList[index];
          return PlannedExpensesRow(
            item: budget,
            onPressed: () =>
                SubscriptionController.instance.confirmPlannedExpense(budget),
          );
        },
      );
    });
  }
}

String getFormattedDateTime() {
  final now = DateTime.now();
  final formatter = DateFormat('EEE MMM d, hh:mma'); // THU AUG 7, 11:19AM
  return formatter.format(now).toUpperCase();
}
