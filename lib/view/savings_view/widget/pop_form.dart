import 'package:fanmint/controllers/savings_controller.dart';
import 'package:fanmint/utility/constants/sizes.dart';
import 'package:fanmint/utility/helpers/helper_functions.dart';
import 'package:fanmint/utility/validators/validator.dart';
import 'package:flutter/material.dart';

void showAddSavingsForm(
    BuildContext context, SavingsController savingsController) {
  showModalBottomSheet(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    context: context,
    builder: (context) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(UniSizes.defaultSpace),
        decoration: BoxDecoration(
          color: HelperFunctions.isDarkMode(context)
              ? Colors.grey[900]
              : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: savingsController.addSavingsFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Create a Savings Account",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: UniSizes.spaceBtwInputFields),

                /// Account Name
                TextFormField(
                  controller: savingsController.accountName,
                  validator: (value) =>
                      UniValidator.validateEmptyText(value, "Account Name"),
                  decoration: const InputDecoration(
                    labelText: "Account Name",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: UniSizes.spaceBtwInputFields),

                /// Reason
                TextFormField(
                  controller: savingsController.reason,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: "Reason (optional)",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: UniSizes.spaceBtwInputFields),

                /// Target Amount + Target Date
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: savingsController.targetAmount,
                        keyboardType: TextInputType.number,
                        validator: (value) => UniValidator.validateEmptyText(
                            value, "Target Amount"),
                        decoration: const InputDecoration(
                          labelText: "Target Amount",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: UniSizes.spaceBtwInputFields),
                    Expanded(
                      child: TextFormField(
                        controller: savingsController.targetDate,
                        readOnly: true,
                        validator: (value) => UniValidator.validateEmptyText(
                            value, "Target Date"),
                        decoration: const InputDecoration(
                          labelText: "Target Date",
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.calendar_today), // 📅 icon
                        ),
                        onTap: () async {
                          final DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(), // prevent past dates
                            lastDate: DateTime(2100),
                          );

                          if (pickedDate != null) {
                            savingsController.targetDate.text =
                                "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: UniSizes.spaceBtwSections),

                /// Save Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      await savingsController.addSavingsAccount();
                    },
                    child: const Text("Save"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
