import 'package:fanmint/models/budget_model.dart';
import 'package:fanmint/repositories/budget_repository.dart';
import 'package:fanmint/utility/device/network_manager.dart';
import 'package:fanmint/utility/popups/fullscreen_loader.dart';
import 'package:fanmint/utility/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class BudgetController extends GetxController {
  static BudgetController get instance => Get.find();

  final GlobalKey<FormState> budgetFormKey = GlobalKey<FormState>();

  // --- Text Controllers ---
  final title = TextEditingController();
  final description = TextEditingController();
  final dailyCost = TextEditingController();

  // --- Budget State ---
  Rx<MaterialColor> selectedColor = Colors.blue.obs;
  Rx<DateTime> startDate = DateTime.now().obs;
  Rx<DateTime> endDate = DateTime.now().add(Duration(days: 30)).obs;

  // --- Loading State ---
  RxBool isLoading = false.obs;

  final RxList<BudgetModel> budgetList = <BudgetModel>[].obs;
  final budgetRepository = Get.put(BudgetRepository());
  Uuid uuid = Uuid();

  @override
  void onInit() {
    super.onInit();
    fetchBudgets();
  }

  Future<void> fetchBudgets() async {
    try {
      final fetchedBudgets = await budgetRepository.fetchBudgets();
      budgetList.assignAll(fetchedBudgets);
    } catch (e) {
      UniLoaders.errorSnackBar(
        title: "Error",
        message: "Failed to fetch expenses: ${e.toString()}",
      );
    }
  }

  void addBudget() async {
    if (isLoading.value) return; // prevent multiple submissions
    isLoading.value = true;

    try {
      UniFullScreenLoader.openLoadingDialog("Saving Budget...");

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        UniFullScreenLoader.stopLoading();
        isLoading.value = false;
        return;
      }

      if (!budgetFormKey.currentState!.validate()) {
        UniFullScreenLoader.stopLoading();
        isLoading.value = false;
        return;
      }

      final daily = double.tryParse(dailyCost.text.trim()) ?? 0;
      final int days = endDate.value.difference(startDate.value).inDays + 1;
      final monthly = daily * 30;
      final total = daily * days;

      final newBudget = BudgetModel(
        id: uuid.v4(),
        title: title.text.trim(),
        description: description.text.trim(),
        dailyCost: daily,
        monthlyPlanned: monthly,
        totalBudget: total,
        remaining: total,
        colorTag: selectedColor.value,
        startDate: startDate.value,
        endDate: endDate.value,
      );

      budgetList.add(newBudget);
      await budgetRepository.saveBudget(newBudget);
      clearForm();

      UniFullScreenLoader.stopLoading();
      UniLoaders.successSnackBar(title: "Success", message: "Budget saved!");
    } catch (e) {
      UniFullScreenLoader.stopLoading();
      UniLoaders.errorSnackBar(title: "Error", message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void clearForm() {
    title.clear();
    description.clear();
    dailyCost.clear();
    selectedColor.value = Colors.blue;
    startDate.value = DateTime.now();
    endDate.value = DateTime.now().add(Duration(days: 30));
  }
}
