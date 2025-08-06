import 'package:fanmint/controllers/subcription_controller.dart';
import 'package:fanmint/models/budget_model.dart';
import 'package:fanmint/utility/constants/colors.dart';
import 'package:fanmint/utility/constants/sizes.dart';
import 'package:fanmint/utility/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

import '../common/color_extension.dart';

class ConfirmedExpensesRow extends StatelessWidget {
  final BudgetModel item;
  final VoidCallback onPressed;

  const ConfirmedExpensesRow(
      {super.key, required this.item, required this.onPressed});

  @override
  Widget build(BuildContext context) {
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
              Icon(Icons.done),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: Text(
                  item.title,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                "\GHC${item.dailyCost}",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                width: UniSizes.spaceBtwItems,
              ),
              TextButton(
                onPressed: () {
                  SubscriptionController.instance.unconfirmExpense(item);
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red,
                  minimumSize: const Size(0, 32),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                ),
                child: const Text("Remove"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
