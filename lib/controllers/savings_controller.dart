import 'package:fanmint/models/savings_account_model.dart';
import 'package:fanmint/models/transaction_model.dart';
import 'package:fanmint/repositories/savings_repository.dart';
import 'package:fanmint/utility/device/network_manager.dart';
import 'package:fanmint/utility/popups/fullscreen_loader.dart';
import 'package:fanmint/utility/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class SavingsController extends GetxController {
  static SavingsController get instance => Get.find();

  /// Form controllers
  final TextEditingController accountName = TextEditingController();
  final TextEditingController reason = TextEditingController();
  final TextEditingController targetAmount = TextEditingController();
  final TextEditingController targetDate = TextEditingController();

  /// List of all savings records (reactive)
  final RxList<SavingsAccountModel> savingsAccountList =
      <SavingsAccountModel>[].obs;

  final savingsRepository = Get.put(SavingsRepository());

  final GlobalKey<FormState> addSavingsFormKey = GlobalKey<FormState>();
  final RxBool enableWithdrawal = true.obs;
  final RxBool isLoading = false.obs;

  Uuid uuid = Uuid();


  @override
  void onInit() {
    getAllSavings();
    super.onInit();
  }


  /// Add a new savings account/entry
  Future<void> addSavingsAccount() async {
    try {
      UniFullScreenLoader.openLoadingDialog("Creating your savings account...");

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        UniFullScreenLoader.stopLoading();
        UniLoaders.errorSnackBar(
          title: "No Connection",
          message: "Please check your internet connection.",
        );
        return;
      }

      if (!addSavingsFormKey.currentState!.validate()) {
        UniFullScreenLoader.stopLoading();
        return;
      }

      if (accountName.text.isEmpty) {
        UniFullScreenLoader.stopLoading();
        UniLoaders.warningSnackBar(
          title: "Oh snap!",
          message: "Please provide an account name.",
        );
        return;
      }

      final saving = SavingsAccountModel(
        id: uuid.v4(),
        accountName: accountName.text.trim(),
        reason: reason.text.trim().isEmpty ? null : reason.text.trim(),
        balance: 0.0,
        dateAdded: DateTime.now(),
        targetAmount: targetAmount.text.trim().isEmpty
            ? null
            : double.tryParse(targetAmount.text.trim()),
        targetDate: targetDate.text.trim().isEmpty
            ? null
            : DateTime.tryParse(targetDate.text.trim()),
        isCompleted: false,
        enableWithdrawal: enableWithdrawal.value,
      );

      await savingsRepository.savePersonalSavingsRecord(saving);
      savingsAccountList.add(saving);

      UniFullScreenLoader.stopLoading();
      UniLoaders.successSnackBar(
        title: "Success",
        message: "Savings account created successfully.",
      );

      clearFormFields();
      Navigator.pop(Get.context!);
    } catch (e) {
      UniFullScreenLoader.stopLoading();
      UniLoaders.errorSnackBar(title: "Error", message: e.toString());
    }
  }

  Future<void> getAllSavings() async {
    try {
      final savings = await savingsRepository.fetchPersonalSavings();
      savingsAccountList.assignAll(savings);
    } catch (e) {
      UniLoaders.errorSnackBar(title: "Error", message: e.toString());
    }
  }

  /// Top up account
  Future<void> topUp(SavingsAccountModel account, double amount) async {
    if (isLoading.value) return; // prevent double action
    isLoading.value = true;

    try {
      final transactionID = uuid.v7();
      final newBalance = (account.balance ?? 0) + amount;

      // Create transaction
      final transaction = TransactionModel(
        id: transactionID,
        date: DateTime.now(),
        amount: amount,
        isDeposit: true,
      );

      // Update account
      account.balance = newBalance;
      account.transactions.add(transaction);

      // Persist in repository
      await savingsRepository.updateSavings(account);

      // Update locally in savingsAccountList
      final index = savingsAccountList.indexWhere((a) => a.id == account.id);
      if (index != -1) {
        savingsAccountList[index] = account; // replace the account fully
        savingsAccountList.refresh();
      }

      UniLoaders.successSnackBar(
        title: "Success",
        message: "Balance topped up successfully.",
      );
    } catch (e) {
      UniLoaders.errorSnackBar(title: "Error", message: e.toString());
    } finally {
      isLoading.value = false; // release lock
    }
  }

  /// Withdraw from account
  Future<void> withdraw(SavingsAccountModel account, double amount) async {
    if (isLoading.value) return; // prevent double action
    isLoading.value = true;

    try {
      if ((account.balance ?? 0) < amount) {
        throw Exception("Insufficient balance");
      }

      final transactionID = uuid.v7();
      final newBalance = (account.balance ?? 0) - amount;
      account.balance = newBalance;

      final transaction = TransactionModel(
        id: transactionID,
        date: DateTime.now(),
        amount: amount,
        isDeposit: false,
      );

      account.transactions.add(transaction);

      await savingsRepository.updateSavings(account);

      final index = savingsAccountList.indexWhere((a) => a.id == account.id);
      if (index != -1) {
        savingsAccountList[index] = account;
        savingsAccountList.refresh();
      }

      UniLoaders.successSnackBar(
        title: "Success",
        message: "Withdrawal successful.",
      );
    } catch (e) {
      UniLoaders.errorSnackBar(title: "Error", message: e.toString());
    } finally {
      isLoading.value = false; // release lock
    }
  }

  /// Clear form fields after creation
  void clearFormFields() {
    accountName.clear();
    reason.clear();
    targetAmount.clear();
    targetDate.clear();
    enableWithdrawal.value = false;
  }
}
