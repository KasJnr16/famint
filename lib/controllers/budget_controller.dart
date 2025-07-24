import 'package:fanmint/common_widget/custom_arc_180_painter.dart';
import 'package:fanmint/models/budget_model.dart';
import 'package:fanmint/utility/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BudgetController extends GetxController {
  static BudgetController get instance => Get.find<BudgetController>();
  final expensesList = <BudgetModel>[].obs;

  final name = TextEditingController();
  final description = TextEditingController();
  final spendAmount = TextEditingController();

  Rx<DateTime?> startDate = Rx<DateTime?>(null);
  Rx<DateTime?> endDate = Rx<DateTime?>(null);

  clear() {
    name.clear();
    spendAmount.clear();
    description.clear();
    startDate.value = null;
    endDate.value = null;
  }

  void addNewExpense({required double totalBudget, required Color color}) {
    if (totalBudget <= 0) {
      Get.back();
      UniLoaders.warningSnackBar(
          title: "Invalid Budget",
          message: "Total budget must be greater than zero");
      return;
    }
    final n = name.text.trim();
    final des = description.text.trim();
    final amt = double.tryParse(spendAmount.text.trim()) ?? 0.0;
    var start = startDate.value;
    var end = endDate.value;
    end ??= start;

    if (n.isEmpty) {
      UniLoaders.warningSnackBar(
          title: "Invalid Input", message: "Expense name cannot be empty");
      return;
    }

    if (amt <= 0) {
      UniLoaders.warningSnackBar(
          title: "Invalid Amount",
          message: "Amount per day must be greater than zero");
      return;
    }

    if (start == null || end == null) {
      UniLoaders.warningSnackBar(
          title: "Missing Dates",
          message: "Start and End dates must be selected");
      return;
    }

    if (end.isBefore(start)) {
      UniLoaders.warningSnackBar(
          title: "Invalid Dates",
          message: "End date cannot be before start date");
      return;
    }

    final totalDays = end.difference(start).inDays + 1;
    final totalSpend = amt * totalDays;

    if (totalSpend > totalBudget) {
      UniLoaders.warningSnackBar(
        title: "Budget Exceeded",
        message:
            "Total spending (GHC ${totalSpend.toStringAsFixed(2)}) exceeds your budget of GHC ${totalBudget.toStringAsFixed(2)}",
      );
      return;
    }

    final leftAmount = totalBudget - totalSpend;

    expensesList.add(
      BudgetModel(
        name: n,
        description: des,
        originalSpendAmount: amt,
        monthlyExpenseAmount: totalSpend,
        totalMonthlyBudget: totalBudget,
        leftAmount: leftAmount,
        startDate: start,
        endDate: end,
        color: color,
      ),
    );

    clear();
    Get.back();
    UniLoaders.successSnackBar(message: "Expense added successfully");
  }

  List<ArcValueModel> get arcValues => expensesList
      .map((e) => ArcValueModel(
          color: e.color,
          value: (e.monthlyExpenseAmount / e.totalMonthlyBudget * 100)
              .clamp(0.0, 100.0)))
      .toList();
}
