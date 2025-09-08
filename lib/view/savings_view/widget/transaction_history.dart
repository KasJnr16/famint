import 'dart:ui';
import 'package:fanmint/models/savings_account_model.dart';
import 'package:fanmint/utility/constants/colors.dart';
import 'package:fanmint/utility/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionHistory extends StatelessWidget {
  const TransactionHistory({
    super.key,
    required this.account,
  });

  final SavingsAccountModel account;

  @override
  Widget build(BuildContext context) {
    // Sort transactions by date descending (latest first)
    final transactions = [...account.transactions]
      ..sort((a, b) => b.date.compareTo(a.date));

    return Container(
      height: 300, // 👈 fixed height for scrollable list
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: HelperFunctions.isDarkMode(context)
            ? UniColors.dark
            : UniColors.lightContainer,
      ),
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: transactions.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          final tx = transactions[index];
          final isDeposit = tx.isDeposit;
          final dateStr = DateFormat("dd MMM yyyy, hh:mm a").format(tx.date);

          return ListTile(
            leading: CircleAvatar(
              backgroundColor: isDeposit
                  ? HelperFunctions.isDarkMode(context)
                      ? UniColors.secondary
                      : UniColors.primary
                  : Colors.red,
              child: Icon(
                isDeposit ? Icons.arrow_downward : Icons.arrow_upward,
                color: Colors.white,
              ),
            ),
            title: Text(
              isDeposit ? "Deposit" : "Withdrawal",
              style: TextStyle(
                color: isDeposit
                    ? HelperFunctions.isDarkMode(context)
                        ? UniColors.secondary
                        : UniColors.primary
                    : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(dateStr),
            trailing: Text(
              "GHC${tx.amount.toStringAsFixed(2)}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          );
        },
      ),
    );
  }
}
