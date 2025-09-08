import 'package:fanmint/models/budget_model.dart';
import 'package:fanmint/utility/constants/colors.dart';
import 'package:fanmint/utility/constants/sizes.dart';
import 'package:fanmint/utility/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../common/color_extension.dart';

class PlannedExpensesRow extends StatelessWidget {
  final BudgetModel item;
  final VoidCallback onPressed;

  const PlannedExpensesRow(
      {super.key, required this.item, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final dark = HelperFunctions.isDarkMode(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onPressed,
        child: Container(
          height: 64,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(
              color: dark ? TColor.border.withOpacity(0.15) : UniColors.light,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          alignment: Alignment.center,
          child: Row(
            children: [
              Container(
                height: 40,
                width: 40,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color:
                      dark ? TColor.gray70.withOpacity(0.5) : UniColors.light,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Text(
                      DateFormat.MMM().format(today), // Shows 'Jul' for July
                      style: TextStyle(
                        color: dark ? TColor.gray30 : UniColors.dark,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      DateFormat.d().format(today), // Shows '17' for 17th
                      style: TextStyle(
                        color: dark ? TColor.gray30 : UniColors.dark,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 8,
              ),

              //name
              Expanded(
                child: Text(
                  item.title,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(
                width: 8,
              ),

              // amount
              Text(
                "GHC ${item.dailyCost}",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                width: UniSizes.spaceBtwItems,
              ),
              
              TextButton(
                onPressed: onPressed,
                style: TextButton.styleFrom(
                  foregroundColor: TColor.primary,
                  minimumSize: const Size(0, 32),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                ),
                child: const Text("Confirm"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
