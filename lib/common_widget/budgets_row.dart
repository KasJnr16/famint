import 'package:fanmint/models/budget_model.dart';
import 'package:fanmint/utility/constants/colors.dart';
import 'package:fanmint/utility/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../common/color_extension.dart';

class BudgetsRow extends StatelessWidget {
  final BudgetModel budget;
  final VoidCallback onPressed;

  const BudgetsRow({super.key, required this.budget, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    var proVal = (budget.leftAmount) / (budget.totalMonthlyBudget);
    final dark = HelperFunctions.isDarkMode(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(
              color: dark ? TColor.border.withOpacity(0.05) : UniColors.light,
            ),
            color: dark ? TColor.gray60.withOpacity(0.1) : UniColors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          alignment: Alignment.center,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Icon(Iconsax.wallet)),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          budget.name,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "\$${budget.leftAmount} left to spend",
                          style: TextStyle(
                              color: TColor.gray30,
                              fontSize: 12,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "\$${budget.monthlyExpenseAmount}",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "of \$${budget.totalMonthlyBudget}",
                          style: TextStyle(
                              color: TColor.gray30,
                              fontSize: 12,
                              fontWeight: FontWeight.w500),
                        ),
                      ]),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              LinearProgressIndicator(
                backgroundColor: dark ? TColor.gray60 : UniColors.light,
                valueColor: AlwaysStoppedAnimation(budget.color),
                minHeight: 3,
                value: proVal,
              )
            ],
          ),
        ),
      ),
    );
  }
}
