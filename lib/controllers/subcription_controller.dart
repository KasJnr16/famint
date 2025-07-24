import 'package:fanmint/models/budget_model.dart';
import 'package:fanmint/utility/popups/loaders.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:fanmint/controllers/budget_controller.dart';

class SubscriptionController extends GetxController {
  static SubscriptionController get instance =>
      Get.find<SubscriptionController>();

  final budgetController = Get.put(BudgetController());

  @override
  void onInit() {
    super.onInit();

    // Watch BudgetController's expensesList for changes
    ever<List<BudgetModel>>(budgetController.expensesList, (_) {
      loadPlannedExpensesForToday();
    });

    everAll([monthlySpent, actualBudget], (_) {
      calculatedBudget.value = actualBudget.value - monthlySpent.value;
    });

    // Initial population
    loadPlannedExpensesForToday();
  }

  RxDouble monthlySpent = 0.0.obs;
  RxDouble actualBudget = 0.0.obs;
  RxDouble calculatedBudget = 0.0.obs;

  TextEditingController setMontlyBudget = TextEditingController();

  RxBool isSpentToday = true.obs;

  RxDouble highestExpense = 0.0.obs;
  RxDouble lowestExpense = 0.0.obs;

  final confirmedExpensesList = <BudgetModel>[].obs;
  final plannedExpensesList = <BudgetModel>[].obs;

  void setBudget() {
    if (setMontlyBudget.text.trim().isEmpty ||
        double.tryParse(setMontlyBudget.text.trim()) == null) {
      Get.back();
      UniLoaders.warningSnackBar(
          title: "Error", message: "Please enter a valid budget");
      return;
    }

    actualBudget.value = double.tryParse(setMontlyBudget.text.trim()) ?? 0.0;
    setMontlyBudget.clear();
    Get.back();
    UniLoaders.successSnackBar(
        title: "Done", message: "your budget has been set");
  }

  void loadPlannedExpensesForToday() {
    final today = DateTime.now();
    plannedExpensesList.clear();

    for (var expense in budgetController.expensesList) {
      final start = expense.startDate;
      final end = expense.endDate;

      if (!today.isBefore(start) && !today.isAfter(end)) {
        plannedExpensesList.add(expense);
      }
    }

    calculateExpenseExtremes();
  }

  void confirmedExpense(BudgetModel item) {
    plannedExpensesList.remove(item);

    if (!confirmedExpensesList.contains(item)) {
      confirmedExpensesList.add(item);
    }

    //Update total monthly spent
    monthlySpent.value += item.originalSpendAmount;

    UniLoaders.successSnackBar(
      title: "Confirmed",
      message: "${item.name} confirmed and added to your expenses",
    );

    calculateExpenseExtremes();
  }

  void unConfirmedExpense(BudgetModel item) {
    confirmedExpensesList.remove(item);

    if (!plannedExpensesList.contains(item)) {
      plannedExpensesList.add(item);
    }

    // Subtract from total monthly spent
    monthlySpent.value -= item.originalSpendAmount;

    UniLoaders.successSnackBar(
      title: "Removed",
      message: "${item.name} has been moved back to planned expenses",
    );

    calculateExpenseExtremes();
  }

  void calculateExpenseExtremes() {
    List<BudgetModel> allExpenses = [
      ...plannedExpensesList,
      ...confirmedExpensesList
    ];

    if (allExpenses.isEmpty) {
      highestExpense.value = 0.0;
      lowestExpense.value = 0.0;
      return;
    }

    allExpenses
        .sort((a, b) => b.originalSpendAmount.compareTo(a.originalSpendAmount));

    highestExpense.value = allExpenses.first.originalSpendAmount;
    lowestExpense.value = allExpenses.last.originalSpendAmount;
  }

  void resetMonthlySpent() {
    monthlySpent.value = 0.0;
    actualBudget.value = 0.0;
    calculatedBudget.value = 0.0;
    confirmedExpensesList.clear();
    plannedExpensesList.clear();
    isSpentToday.value = true;
  }
  

}
