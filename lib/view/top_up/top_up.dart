import 'package:fanmint/controllers/account_controller.dart';
import 'package:fanmint/utility/constants/colors.dart';
import 'package:fanmint/utility/constants/sizes.dart';
import 'package:fanmint/utility/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TopUpView extends StatelessWidget {
  final String? accountTitle;
  final String? accountId;

  const TopUpView({
    super.key,
    this.accountTitle,
    this.accountId,
    this.onPressed,
    this.pageTitle,
    this.widget,
  });

  final void Function()? onPressed;
  final String? pageTitle;
  final Widget? widget;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(UniSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //header
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
                  pageTitle ?? "Top up",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),

            const SizedBox(height: UniSizes.spaceBtwSections),
            Text("Enter the details of your transaction",
                style: Theme.of(context).textTheme.labelMedium),

            SizedBox(
              height: UniSizes.spaceBtwSections,
            ),
            widget ??
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: UniSizes.spaceBtwItems),
                    Text(accountTitle ?? "",
                        style: Theme.of(context).textTheme.titleMedium),
                    Text(accountId ?? "",
                        style: Theme.of(context).textTheme.bodySmall),
                    const SizedBox(height: UniSizes.spaceBtwSections),

                    // Amount Input
                    TextField(
                      controller: AccountController.instance.amount,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Enter Amount",
                        prefixText: "₵ ",
                      ),
                    ),

                    const SizedBox(height: UniSizes.spaceBtwSections),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: onPressed,
                        child: Text("Confirm"),
                      ),
                    ),
                  ],
                )
          ],
        ),
      ),
    );
  }
}
