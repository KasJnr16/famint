import 'package:fanmint/common/color_extension.dart';
import 'package:fanmint/common_widget/animation_loader.dart';
import 'package:fanmint/common_widget/circular_loader.dart';
import 'package:fanmint/utility/constants/colors.dart';
import 'package:fanmint/utility/constants/image_strings.dart';
import 'package:fanmint/utility/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UniFullScreenLoader {
  static void openLoadingDialog(String text, {String? animation}) {
    showDialog(
      context: Get.overlayContext!,
      barrierDismissible: false,
      builder: (_) => PopScope(
        canPop: false,
        child: Container(
          color: HelperFunctions.isDarkMode(Get.context!)
              ? Colors.black
              : TColor.primary,
          width: double.infinity,
          height: double.infinity,
          child: Center(
            child: UniCircularLoader(),
          ),
        ),
      ),
    );
  }

  static void appPageLoading({String animation = UniImages.loader}) {
    showDialog(
      context: Get.overlayContext!,
      barrierDismissible: false,
      builder: (_) => PopScope(
        canPop: false,
        child: Container(
          color: HelperFunctions.isDarkMode(Get.context!)
              ? UniColors.dark
              : UniColors.white,
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              UniAnimationLoaderWidget(animation: animation),
            ],
          ),
        ),
      ),
    );
  }

  static stopLoading() {
    Navigator.of(Get.overlayContext!).pop();
  }
}
