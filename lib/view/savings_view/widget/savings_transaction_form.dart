import 'package:fanmint/controllers/account_controller.dart';
import 'package:fanmint/controllers/payment_controller.dart';
import 'package:fanmint/controllers/savings_controller.dart';
import 'package:fanmint/controllers/user/user_controller.dart';
import 'package:fanmint/models/momo_wallet_model.dart';
import 'package:fanmint/models/savings_account_model.dart';
import 'package:fanmint/utility/constants/colors.dart';
import 'package:fanmint/utility/constants/sizes.dart';
import 'package:fanmint/utility/popups/fullscreen_loader.dart';
import 'package:fanmint/utility/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SavingsTransactionForm extends StatefulWidget {
  final bool isTopUp; // true = Top Up, false = Withdraw

  final SavingsAccountModel account;

  const SavingsTransactionForm(
      {super.key, required this.isTopUp, required this.account});

  @override
  State<SavingsTransactionForm> createState() => _SavingsTransactionFormState();
}

class _SavingsTransactionFormState extends State<SavingsTransactionForm> {
  final savingsController = SavingsController.instance;
  final accountController = AccountController.instance;

  final TextEditingController amountController = TextEditingController();

  dynamic selectedFunding; // MoMoWalletModel or BankModel

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Step 2: Select Funding Source (MoMo or Bank)
          DropdownButtonFormField<dynamic>(
            decoration: const InputDecoration(
              labelText: "Select Funding Source",
              border: OutlineInputBorder(),
            ),
            items: [
              ...accountController.momoWallets.map((wallet) {
                return DropdownMenuItem(
                  value: wallet,
                  child: Text("${wallet.network} - ${wallet.phoneNumber}"),
                );
              }),
              ...accountController.banks.map((bank) {
                return DropdownMenuItem(
                  value: bank,
                  child: Text("${bank.accountName} - ${bank.accountNumber}"),
                );
              }),
            ],
            value: selectedFunding,
            onChanged: (value) {
              setState(() => selectedFunding = value);
            },
          ),
          const SizedBox(height: UniSizes.spaceBtwItems),

          /// Step 3: Amount Input
          TextField(
            controller: amountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: "Enter Amount",
              prefixText: "₵ ",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: UniSizes.spaceBtwSections),

          /// Step 4: Confirm Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.isTopUp ? null : UniColors.error,
              ),
              onPressed: () async {
                UniFullScreenLoader.openLoadingDialog("Processing...");
                try {
                  final user = UserController.instance.currentUser.value;

                  if (selectedFunding == null ||
                      amountController.text.isEmpty) {
                    UniLoaders.warningSnackBar(
                      message:
                          "Select savings, funding source, and enter amount.",
                    );
                    return;
                  }

                  final amount = double.tryParse(amountController.text.trim());
                  if (amount == null || amount <= 0) {
                    UniLoaders.warningSnackBar(
                        message: "Enter a valid amount.");
                    return;
                  }

                  if (widget.isTopUp) {
                    // ✅ Top Up
                    final success =
                        await PaymentController.instance.makePayment(
                      customerEmail: user.email,
                      customerFullname: user.fullname,
                      amount: amount,
                      context: context,
                    );

                    await savingsController.topUp(widget.account, amount);
                    UniLoaders.successSnackBar(
                      message:
                          "Top Up of ₵${amount.toStringAsFixed(2)} successful.",
                    );
                  } else {
                    // ✅ Withdraw
                    final today = DateTime.now();
                    if (today.isBefore(widget.account.targetDate!)) {
                      UniLoaders.warningSnackBar(
                        title: "Not Allowed",
                        message:
                            "You can only withdraw after ${widget.account.targetDate!.toLocal().toString().split(' ')[0]}.",
                      );
                      return;
                    }

                    bool withdrawalSuccess = false;
                    if (selectedFunding is MoMoWalletModel) {
                      withdrawalSuccess =
                          await PaymentController.instance.withdrawToMoMo(
                        momoNumber: selectedFunding.phoneNumber,
                        network: selectedFunding.network,
                        accountName: user.fullname,
                        amount: amount,
                      );
                    } else {
                      withdrawalSuccess =
                          await PaymentController.instance.withdraw(
                        bankCode: selectedFunding.bankCode,
                        accountNumber: selectedFunding.accountNumber,
                        accountName: selectedFunding.accountName,
                        amount: amount,
                      );
                    }

                    if (!withdrawalSuccess) {
                      UniLoaders.warningSnackBar(message: "Withdrawal failed.");
                      return;
                    }

                    await savingsController.withdraw(widget.account, amount);
                    UniLoaders.successSnackBar(
                      message:
                          "Withdrawal of ₵${amount.toStringAsFixed(2)} successful.",
                    );
                  }

                  Get.back();
                } catch (e) {
                  UniLoaders.warningSnackBar(message: "Error: $e");
                } finally {
                  UniFullScreenLoader.stopLoading();
                }
              },
              child: Text(
                  widget.isTopUp ? "Confirm Top Up" : "Confirm Withdrawal"),
            ),
          ),
        ],
      );
    });
  }
}
