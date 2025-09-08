import 'package:fanmint/controllers/account_controller.dart';
import 'package:fanmint/repositories/expense_repository.dart';
import 'package:fanmint/utility/device/network_manager.dart';
import 'package:fanmint/utility/popups/fullscreen_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fanmint/models/expense_model.dart';
import 'package:fanmint/utility/popups/loaders.dart';
import 'package:uuid/uuid.dart';

class ExpenseController extends GetxController {
  static ExpenseController get instance => Get.find<ExpenseController>();

  // --- Text Controllers ---
  final title = TextEditingController();
  final expenseAmount = TextEditingController();

  // --- Dropdown / Selector Values ---
  RxString selectedCategory = 'Food'.obs;
  RxString selectedAccount = 'MoMo'.obs;
  Rx<DateTime> selectedDate = DateTime.now().obs;

  GlobalKey<FormState> expenseFormKey = GlobalKey<FormState>();

  // --- Expense List ---
  final RxList<ExpenseModel> expensesList = <ExpenseModel>[].obs;
  final expenseRepository = Get.put(ExpenseRepository());

  Uuid uuid = Uuid();

  @override
  void onInit() {
    super.onInit();
    fetchExpenses(); // fetch expenses on controller init
  }

  void addExpense() async {
    try {
      // Start loading
      UniFullScreenLoader.openLoadingDialog("Adding Expense...");

      if (AccountController.instance.momoWallets.isEmpty &&
          AccountController.instance.banks.isEmpty) {
        UniFullScreenLoader.stopLoading();
        UniLoaders.warningSnackBar(
          title: "No Accounts Found",
          message: "You need to add your Account first.",
        );
        return;
      }

      // Check network (if needed for cloud sync)
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        UniFullScreenLoader.stopLoading();
        return;
      }

      // Validate form
      if (!expenseFormKey.currentState!.validate()) {
        UniFullScreenLoader.stopLoading();
        return;
      }

      // Parse inputs
      final parsedAmount = double.tryParse(expenseAmount.text.trim()) ?? 0.0;
      if (parsedAmount <= 0) {
        UniFullScreenLoader.stopLoading();
        UniLoaders.errorSnackBar(
          title: "Invalid Amount",
          message: "Please enter a valid number greater than 0.",
        );
        return;
      }

      final newExpense = ExpenseModel(
        id: uuid.v4(),
        title: title.text.trim(),
        amount: parsedAmount,
        category: selectedCategory.value,
        accountType: selectedAccount.value,
        date: selectedDate.value,
      );

      // Add to list
      await expenseRepository.saveExpense(newExpense);
      expensesList.add(newExpense);

      clearForm();

      // Stop loading and close bottom sheet
      UniFullScreenLoader.stopLoading();

      // Success message
      UniLoaders.successSnackBar(
        title: "Success",
        message: "Expense added successfully!",
      );
    } catch (e) {
      UniFullScreenLoader.stopLoading();
      UniLoaders.errorSnackBar(
        title: "Oh Snap!",
        message: "Something went wrong: ${e.toString()}",
      );
    }
  }

  void clearForm() {
    // Clear form fields
    title.clear();
    expenseAmount.clear();
    selectedCategory.value = 'Food';
    selectedAccount.value = 'MoMo';
    selectedDate.value = DateTime.now();
  }

  Future<void> confrimExpense(ExpenseModel expense) async {
    await expenseRepository.saveExpense(expense);
  }

  Future<void> removeExpense(String id) async {
    await expenseRepository.removeExpense(id);
  }

  Future<void> fetchExpenses() async {
    try {
      final fetchedExpenses = await expenseRepository.fetchExpenses();
      expensesList.assignAll(fetchedExpenses);
    } catch (e) {
      UniLoaders.errorSnackBar(
        title: "Error",
        message: "Failed to fetch expenses: ${e.toString()}",
      );
    }
  }
}
