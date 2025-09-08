import 'package:fanmint/controllers/subcription_controller.dart';
import 'package:fanmint/utility/constants/colors.dart';
import 'package:fanmint/utility/constants/sizes.dart';
import 'package:fanmint/utility/helpers/helper_functions.dart';
import 'package:fanmint/view/savings_view/savings_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SavingsCard extends StatelessWidget {
  const SavingsCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final subscriptionController = SubscriptionController.instance;
    return GestureDetector(
      onTap: () => Get.to(() => SavingsView()),
      child: Container(
        width: double.infinity,
        height: 180,
        margin: const EdgeInsets.all(12),
        padding: EdgeInsets.all(UniSizes.md),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: AssetImage("assets/img/savings.png"),
            fit: BoxFit.cover,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Start your journey towards financial freedom by creating a savings account. ",
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .apply(color: UniColors.white),
              textAlign: TextAlign.left,
            ),

            // Save button (bottom left)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 6,
                    horizontal: 12,
                  ),
                  decoration: BoxDecoration(
                    color: HelperFunctions.isDarkMode(context)
                        ? UniColors.secondary
                        : UniColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "Save",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .apply(color: UniColors.white),
                  ),
                ),

                // amount
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 6,
                    horizontal: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Obx(
                    () => Text(
                      "GHC ${subscriptionController.totalSavingsAmount.value.toStringAsFixed(2)}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
