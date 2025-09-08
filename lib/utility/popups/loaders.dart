import 'package:fanmint/common/color_extension.dart';
import 'package:fanmint/utility/constants/colors.dart';
import 'package:fanmint/utility/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UniLoaders {
  static hideSnackBar() =>
      ScaffoldMessenger.of(Get.context!).hideCurrentSnackBar();

  static customToast({required message}) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        elevation: 0,
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.transparent,
        content: Container(
          padding: const EdgeInsets.all(12.0),
          margin: const EdgeInsets.symmetric(horizontal: 30),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: HelperFunctions.isDarkMode(Get.context!)
                ? TColor.gray10.withOpacity(0.9)
                : TColor.gray.withOpacity(0.9),
          ),
          child: Center(
            child: Text(message,
                style: Theme.of(Get.context!).textTheme.labelLarge),
          ),
        ),
      ),
    );
  }

  static successSnackBar(
      {title = "Congratulations", message = "", duration = 3}) {
    Get.snackbar(
      title,
      message,
      isDismissible: true,
      shouldIconPulse: true,
      colorText: TColor.white,
      backgroundColor: HelperFunctions.isDarkMode(Get.context!)
          ? UniColors.secondary
          : UniColors.primary,
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: duration),
      margin: const EdgeInsets.all(10),
      icon: Icon(Icons.check, color: TColor.white),
    );
  }

  static warningSnackBar({title = "Oh Snap!", message = ""}) {
    Get.snackbar(
      title,
      message,
      isDismissible: true,
      shouldIconPulse: true,
      colorText: TColor.white,
      backgroundColor: Colors.orange,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(20),
      icon: Icon(Icons.check, color: TColor.white),
    );
  }

  static errorSnackBar({required title, message = ""}) {
    Get.snackbar(
      title,
      message,
      isDismissible: true,
      shouldIconPulse: true,
      colorText: TColor.white,
      backgroundColor: Colors.red.shade600,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(20),
      icon: Icon(Icons.check, color: TColor.white),
    );
  }
}
