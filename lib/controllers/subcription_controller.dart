import 'package:fanmint/controllers/account_controller.dart';
import 'package:fanmint/controllers/expense_controller.dart';
import 'package:fanmint/controllers/savings_controller.dart';
import 'package:fanmint/models/budget_model.dart';
import 'package:fanmint/models/expense_model.dart';
import 'package:fanmint/models/momo_wallet_model.dart';
import 'package:fanmint/models/savings_account_model.dart';
import 'package:fanmint/repositories/budget_repository.dart';
import 'package:get/get.dart';
import 'package:fanmint/controllers/budget_controller.dart';
import 'package:uuid/uuid.dart';

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

  RxDouble totalSavingsAmount = 0.0.obs;

  final confirmedExpensesList = <BudgetModel>[].obs;
  final plannedExpensesList = <BudgetModel>[].obs;

  RxBool isLoading = false.obs;

  Uuid uuid = Uuid();

  @override
  void onInit() {
    super.onInit();

    // Load planned expenses on startup
    loadPlannedExpensesForToday();

    _listenToAccountChanges();
    _listenToExpenseChanges();
    _listenToBudgetChanges();
    _listenToSavingsAccountsChanges();

    //set correct init amount
    calculatedBalance.value = totalBalance.value - totalUsedBalance.value;
  }

  void _listenToSavingsAccountsChanges() {
    final savingsController = SavingsController.instance;
    ever<List<SavingsAccountModel>>(
        savingsController.savingsAccountList, (_) => _getTotalSavingsBalance());
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

  void _getTotalSavingsBalance() {
    final savingsController = SavingsController.instance;
    double total = 0;

    for (var account in savingsController.savingsAccountList) {
      total += account.balance!;
    }

    totalSavingsAmount.value = total;
  }

  void _recalculateBalance() {
    final accountController = AccountController.instance;
    double total = 0;

    // Merge momo
    for (var momo in accountController.momoWallets) {
      total += momo.amount!;
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
    final todayKey = "${today.year}-${today.month}-${today.day}"; // YYYY-MM-DD

    final budgets = BudgetController.instance.budgetList;

    plannedExpensesList.clear();

    for (var budget in budgets) {
      final start = DateTime(
          budget.startDate.year, budget.startDate.month, budget.startDate.day);
      final end = DateTime(
          budget.endDate.year, budget.endDate.month, budget.endDate.day);
      final now = DateTime(today.year, today.month, today.day);

      final alreadyConfirmed =
          budget.confirmedDates?.contains(todayKey) ?? false;

      if (!alreadyConfirmed &&
          (now.isAtSameMomentAs(start) ||
              now.isAtSameMomentAs(end) ||
              (now.isAfter(start) && now.isBefore(end)))) {
        plannedExpensesList.add(budget);
      }
    }
  }

  void confirmPlannedExpense(BudgetModel budget) async {
    if (isLoading.value) return;
    isLoading.value = true;

    try {
      final today = DateTime.now();
      final todayKey = "${today.year}-${today.month}-${today.day}";

      // 1. Update confirmedDates
      final updatedConfirmedDates =
          List<String>.from(budget.confirmedDates ?? []);
      if (!updatedConfirmedDates.contains(todayKey)) {
        updatedConfirmedDates.add(todayKey);
      }

      final updatedBudget =
          budget.copyWith(confirmedDates: updatedConfirmedDates);

      // 2. Persist the budget update in Firestore
      await BudgetRepository.instance.updateBudget(updatedBudget);

      // 3. Move to confirmed
      plannedExpensesList.remove(budget);
      confirmedExpensesList.add(updatedBudget);

      // 4. Create Expense entry
      final expense = ExpenseModel(
        id: uuid.v4(),
        title: budget.title,
        amount: budget.dailyCost,
        category: "Planned",
        accountType: "Budget",
        date: DateTime.now(),
      );

      ExpenseController.instance.expensesList.add(expense);
      await ExpenseController.instance.confrimExpense(expense);
    } finally {
      isLoading.value = false;
    }
  }

  void unconfirmExpense(BudgetModel budget) async {
    if (isLoading.value) return;
    isLoading.value = true;

    try {
      final today = DateTime.now();
      final todayKey = "${today.year}-${today.month}-${today.day}";

      final updatedConfirmedDates =
          List<String>.from(budget.confirmedDates ?? []);
      updatedConfirmedDates.remove(todayKey);

      final updatedBudget =
          budget.copyWith(confirmedDates: updatedConfirmedDates);

      await BudgetRepository.instance.updateBudget(updatedBudget);

      confirmedExpensesList.remove(budget);
      plannedExpensesList.add(updatedBudget);

      // Remove matching expense entry for today
      final expenseController = ExpenseController.instance;
      final todayOnly = DateTime(today.year, today.month, today.day);

      final matchingExpenses = expenseController.expensesList.where((expense) {
        final expenseDate =
            DateTime(expense.date.year, expense.date.month, expense.date.day);
        return expense.title == budget.title &&
            expense.amount == budget.dailyCost &&
            expense.accountType == "Budget" &&
            expense.category == "Planned" &&
            expenseDate == todayOnly;
      }).toList();

      for (var expense in matchingExpenses) {
        expenseController.expensesList.remove(expense);
        await expenseController.removeExpense(expense.id);
      }
    } finally {
      isLoading.value = false;
    }
  }
}
