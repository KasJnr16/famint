import 'package:fanmint/common/color_extension.dart';
import 'package:fanmint/common_widget/section_heading.dart';
import 'package:fanmint/controllers/budget_controller.dart';
import 'package:fanmint/utility/constants/colors.dart';
import 'package:fanmint/utility/constants/sizes.dart';
import 'package:fanmint/utility/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddBudgetView extends StatelessWidget {
  const AddBudgetView({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunctions.isDarkMode(context);
    final controller = BudgetController.instance;
    return Scaffold(
      backgroundColor: dark ? TColor.gray : UniColors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(UniSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                      onPressed: () => Get.back(),
                      color: HelperFunctions.isDarkMode(context)
                          ? UniColors.secondary
                          : UniColors.primary,
                      icon: Icon(Icons.arrow_back)),
                  Text(
                    "Plan Budget",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ],
              ),
              const SizedBox(height: UniSizes.spaceBtwSections),

              //options
              UniSectionHeading(
                  title: "Budget Details", showActionButton: false),
              const SizedBox(height: UniSizes.spaceBtwSections),
              Form(
                key: controller.budgetFormKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: controller.title,
                            validator: (value) =>
                                value!.isEmpty ? "Enter budget title" : null,
                            decoration: const InputDecoration(
                                labelText: "Budget Title"),
                          ),
                        ),
                        SizedBox(width: UniSizes.spaceBtwItems),
                        Expanded(
                          child: TextFormField(
                            controller: controller.dailyCost,
                            validator: (value) =>
                                value!.isEmpty ? "Enter daily cost" : null,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                labelText: "Daily Cost (GHC)"),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: UniSizes.spaceBtwItems),
                    TextFormField(
                      maxLines: 2,
                      controller: controller.description,
                      validator: (value) =>
                          value!.isEmpty ? "Enter a description" : null,
                      decoration:
                          const InputDecoration(labelText: "Description"),
                    ),
                    SizedBox(height: UniSizes.spaceBtwItems),
                    Row(
                      children: [
                        // Start Date Picker
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: controller.startDate.value,
                                firstDate: DateTime(2022),
                                lastDate: DateTime(2100),
                              );
                              if (picked != null) {
                                controller.startDate.value = picked;
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 16),
                              margin: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade400),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Obx(
                                    () => Expanded(
                                      child: Text(
                                        "Start: ${controller.startDate.value.toLocal().toString().split(" ")[0]}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // End Date Picker
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: controller.endDate.value,
                                firstDate: controller.startDate.value,
                                lastDate: DateTime(2100),
                              );
                              if (picked != null) {
                                controller.endDate.value = picked;
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 16),
                              margin: const EdgeInsets.only(left: 8),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade400),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Obx(
                                    () => Expanded(
                                      child: Text(
                                        "End: ${controller.endDate.value.toLocal().toString().split(" ")[0]}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: UniSizes.spaceBtwItems),
                  ],
                ),
              ),

              const SizedBox(height: UniSizes.spaceBtwItems),

              const SizedBox(height: 110),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(UniSizes.defaultSpace),
        child: SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () => controller.addBudget(),
            child: Text("Save Budget"),
          ),
        ),
      ),
    );
  }
}
