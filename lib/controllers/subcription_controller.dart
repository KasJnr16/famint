import 'package:fanmint/controllers/account_controller.dart';
import 'package:fanmint/controllers/expense_controller.dart';
import 'package:fanmint/models/budget_model.dart';
import 'package:fanmint/models/expense_model.dart';
import 'package:fanmint/models/momo_wallet_model.dart';
import 'package:get/get.dart';
import 'package:fanmint/controllers/budget_controller.dart';

class SubscriptionController extends GetxController {
  static SubscriptionController get instance =>
      Get.find<SubscriptionController>();

  final RxBool isHidden = true.obs;

  RxDouble totalBalance = 0.0.obs;
  RxDouble totalUsedBalance = 0.0.obs;
  RxDouble calculatedBalance = 0.0.obs;

  RxBool isSpentToday = true.obs;

  RxDouble highestExpense = 0.0.obs;
  RxDouble lowestExpense = 0.0.obs;

  final confirmedExpensesList = <BudgetModel>[].obs;
  final plannedExpensesList = <BudgetModel>[].obs;

  @override
  void onInit() {
    super.onInit();

    // Load planned expenses on startup
    loadPlannedExpensesForToday();

    _listenToAccountChanges();
    _listenToExpenseChanges();
    _listenToBudgetChanges();
  }

  void _listenToBudgetChanges() {
    final budgetController = BudgetController.instance;
    ever<List<BudgetModel>>(
        budgetController.budgetList, (_) => loadPlannedExpensesForToday());
  }

  void _listenToAccountChanges() {
    final accountController = AccountController.instance;

    // Combine and compute totals reactively
    ever<List<MoMoWalletModel>>(
        accountController.momoWallets, (_) => _recalculateBalance());
  }

  void _recalculateBalance() {
    final accountController = AccountController.instance;
    double total = 0;

    // Merge momo
    for (var momo in accountController.momoWallets) {
      total += momo.amount;
    }

    totalBalance.value = total;
  }

  void _listenToExpenseChanges() {
    final expenseController = ExpenseController.instance;

    // Combine and compute totals reactively
    ever<List<ExpenseModel>>(
        expenseController.expensesList, (_) => _recalculateTotalUsedBalance());
  }

  void _recalculateTotalUsedBalance() {
    final expenseController = ExpenseController.instance;

    double used = 0.0;
    for (var expense in expenseController.expensesList) {
      used += expense.amount;
    }

    totalUsedBalance.value = used;
    calculatedBalance.value = totalBalance.value - totalUsedBalance.value;
  }

  void reset() {
    totalBalance.value = 0.0;
    totalUsedBalance.value = 0.0;
    calculatedBalance.value = 0.0;
    confirmedExpensesList.clear();
    plannedExpensesList.clear();
    isSpentToday.value = true;
  }

  void loadPlannedExpensesForToday() {
    final today = DateTime.now();
    final budgets = BudgetController.instance.budgetList;

    plannedExpensesList.clear();

    for (var budget in budgets) {
      final start = DateTime(
          budget.startDate.year, budget.startDate.month, budget.startDate.day);
      final end = DateTime(
          budget.endDate.year, budget.endDate.month, budget.endDate.day);
      final now = DateTime(today.year, today.month, today.day);

      if (now.isAtSameMomentAs(start) ||
          now.isAtSameMomentAs(end) ||
          (now.isAfter(start) && now.isBefore(end))) {
        // Still active budget
        plannedExpensesList.add(budget);
      }
    }
  }

  void confirmPlannedExpense(BudgetModel budget) {
    // 1. Remove from planned
    plannedExpensesList.remove(budget);

    // 2. Add to confirmed
    confirmedExpensesList.add(budget);

    // 3. Create ExpenseModel version
    final expense = ExpenseModel(
      title: budget.title,
      amount: budget.dailyCost,
      category: "Planned",
      accountType: "Budget",
      date: DateTime.now(),
    );

    // 4. Add to main expense list
    ExpenseController.instance.expensesList.add(expense);
  }

  void unconfirmExpense(BudgetModel budget) {
    // 1. Remove from confirmed list
    confirmedExpensesList.remove(budget);

    // 2. Re-add to planned list
    plannedExpensesList.add(budget);

    // 3. Remove its matching ExpenseModel from the expense list
    final expenseController = ExpenseController.instance;

    // Find the matching expense entry based on title, amount, and date
    final today = DateTime.now();
    final todayOnly = DateTime(today.year, today.month, today.day);

    expenseController.expensesList.removeWhere((expense) {
      final expenseDate =
          DateTime(expense.date.year, expense.date.month, expense.date.day);
      return expense.title == budget.title &&
          expense.amount == budget.dailyCost &&
          expense.accountType == "Budget" &&
          expense.category == "Planned" &&
          expenseDate == todayOnly;
    });
  }
}
