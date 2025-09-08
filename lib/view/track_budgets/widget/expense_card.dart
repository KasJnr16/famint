import 'package:fanmint/utility/constants/colors.dart';
import 'package:fanmint/utility/helpers/helper_functions.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:fanmint/models/expense_model.dart';
import 'package:fanmint/utility/constants/sizes.dart';

class ExpenseCard extends StatelessWidget {
  final ExpenseModel expense;

  const ExpenseCard({super.key, required this.expense});

  @override
  Widget build(BuildContext context) {
    final formattedDate =
        DateFormat('dd MMM yy').format(expense.date).toUpperCase();
    final formattedAmount = "GHC ${expense.amount.toStringAsFixed(2)}";

    return Container(
      margin: const EdgeInsets.only(bottom: UniSizes.spaceBtwItems),
      padding: const EdgeInsets.all(UniSizes.md),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(UniSizes.cardRadiusMd),
        color: HelperFunctions.isDarkMode(context)
            ? UniColors.dark
            : UniColors.lightContainer,
      ),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // LEFT COLUMN (Title + Date)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(expense.title,
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 4),
              Text(formattedDate,
                  style: Theme.of(context).textTheme.labelSmall),
            ],
          ),

          // RIGHT COLUMN (Amount + Account)
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                formattedAmount,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                expense.accountType,
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
