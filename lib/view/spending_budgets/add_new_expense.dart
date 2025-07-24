import 'package:dotted_border/dotted_border.dart';
import 'package:fanmint/common/color_extension.dart';
import 'package:fanmint/controllers/budget_controller.dart';
import 'package:fanmint/controllers/subcription_controller.dart';
import 'package:fanmint/utility/constants/colors.dart';
import 'package:fanmint/utility/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddNewExpenseButton extends StatelessWidget {
  const AddNewExpenseButton({
    super.key,
    required this.controller,
    required this.subController,
    required this.dark,
  });

  final BudgetController controller;
  final SubscriptionController subController;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          final selectedColor = Rx<Color>(TColor.primary10);

          Get.defaultDialog(
            title: "Add Monthly Expense",
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    controller: controller.name,
                    decoration: const InputDecoration(labelText: "Name"),
                  ),
                  const SizedBox(
                    height: UniSizes.spaceBtwItems,
                  ),
                  TextField(
                    controller: controller.spendAmount,
                    decoration:
                        const InputDecoration(labelText: "Amount (GHC)"),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(
                    height: UniSizes.spaceBtwItems,
                  ),
                  TextField(
                    controller: controller.description,
                    decoration: const InputDecoration(labelText: "Description"),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(() => Text(controller.startDate.value == null
                          ? "Start date"
                          : "Start: ${controller.startDate.value!.day}/${controller.startDate.value!.month}")),
                      TextButton(
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now()
                                .subtract(const Duration(days: 30)),
                            lastDate:
                                DateTime.now().add(const Duration(days: 60)),
                          );
                          if (picked != null)
                            controller.startDate.value = picked;
                        },
                        child: const Text("Pick Start"),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(() => Text(controller.endDate.value == null
                          ? "End date"
                          : "End: ${controller.endDate.value!.day}/${controller.endDate.value!.month}")),
                      TextButton(
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now()
                                .subtract(const Duration(days: 30)),
                            lastDate:
                                DateTime.now().add(const Duration(days: 60)),
                          );
                          if (picked != null) controller.endDate.value = picked;
                        },
                        child: const Text("Pick End"),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text("Choose a color:"),
                  Obx(() => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ...[
                            TColor.primary10,
                            TColor.secondary,
                            TColor.secondaryG
                          ].map((color) {
                            return GestureDetector(
                              onTap: () => selectedColor.value = color,
                              child: Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: color,
                                  border: Border.all(
                                    color: selectedColor.value == color
                                        ? Colors.black
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                              ),
                            );
                          })
                        ],
                      )),
                ],
              ),
            ),
            confirm: ElevatedButton(
              onPressed: () {
                controller.addNewExpense(
                    color: selectedColor.value,
                    totalBudget: subController.calculatedBudget.value);
              },
              child: const Text("Add"),
            ),
            cancel: OutlinedButton(
              onPressed: () => Get.back(),
              child: const Text("Cancel"),
            ),
          );
        },
        child: DottedBorder(
          dashPattern: const [5, 4],
          strokeWidth: 1,
          borderType: BorderType.RRect,
          radius: const Radius.circular(16),
          color: dark ? TColor.border.withOpacity(0.1) : UniColors.darkGrey,
          child: Container(
            height: 64,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Add new monthly expense",
                  style: TextStyle(
                    color: TColor.gray40,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Image.asset(
                  "assets/img/add.png",
                  width: 12,
                  height: 12,
                  color: TColor.gray40,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
