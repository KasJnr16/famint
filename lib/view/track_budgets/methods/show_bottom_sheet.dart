import 'package:fanmint/common_widget/section_heading.dart';
import 'package:fanmint/controllers/expense_controller.dart';
import 'package:fanmint/utility/constants/sizes.dart';
import 'package:fanmint/utility/validators/validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

void showAddExpenseBottomSheet(BuildContext context) {
  final controller = ExpenseController.instance;

  showModalBottomSheet(
    context: context,
    // isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 20,
          left: 20,
          right: 20,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: controller.expenseFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UniSectionHeading(
                  title: "Add Expense",
                  showActionButton: false,
                ),
                const SizedBox(height: UniSizes.spaceBtwItems),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: controller.title,
                        validator: (value) => UniValidator.validateEmptyText(
                            "Expense Title", value),
                        decoration: InputDecoration(labelText: "Expense Title"),
                      ),
                    ),
                    const SizedBox(width: UniSizes.spaceBtwItems),
                    Expanded(
                      child: TextFormField(
                        controller: controller.expenseAmount,
                        validator: (value) =>
                            UniValidator.validateEmptyText("Amount", value),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: "Amount (GHC)"),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: UniSizes.spaceBtwItems),
                DropdownButtonFormField<String>(
                  value: controller.selectedCategory.value,
                  onChanged: (value) =>
                      controller.selectedCategory.value = value ?? "Food",
                  items: ["Food", "Transport", "Shopping", "Bills"]
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  decoration: InputDecoration(labelText: "Category"),
                ),
                const SizedBox(height: UniSizes.spaceBtwItems),
                DropdownButtonFormField<String>(
                  value: controller.selectedAccount.value,
                  onChanged: (value) =>
                      controller.selectedAccount.value = value ?? "MoMo",
                  items: ["MoMo", "Bank"]
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  decoration: InputDecoration(labelText: "Account Type"),
                ),
                const SizedBox(height: UniSizes.spaceBtwItems),
                GestureDetector(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: controller.selectedDate.value,
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) controller.selectedDate.value = picked;
                  },
                  child: InputDecorator(
                    decoration: InputDecoration(labelText: "Date"),
                    child: Text("${controller.selectedDate.value.toLocal()}"
                        .split(' ')[0]),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    child: Text("Save Expense"),
                    onPressed: () {
                      Get.back();
                      controller.addExpense();
                    },
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      );
    },
  );
}
