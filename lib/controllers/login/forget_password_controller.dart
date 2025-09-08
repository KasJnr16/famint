import 'package:fanmint/repositories/authentication/authentication_repository.dart';
import 'package:fanmint/utility/device/network_manager.dart';
import 'package:fanmint/utility/popups/fullscreen_loader.dart';
import 'package:fanmint/utility/popups/loaders.dart';
import 'package:fanmint/view/login/password_config/reset_password.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class ForgetPasswordController extends GetxController {
  static ForgetPasswordController get instance => Get.find();

  final email = TextEditingController();
  GlobalKey<FormState> forgetPasswordFormKey = GlobalKey<FormState>();

  sendPasswordResetEmail() async {
    try {
      UniFullScreenLoader.openLoadingDialog("We are processing your request");

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        UniFullScreenLoader.stopLoading();
        return;
      }

      if (!forgetPasswordFormKey.currentState!.validate()) {
        UniFullScreenLoader.stopLoading();
        return;
      }

      await AuthenticationRepository.instance
          .sendPasssowrdResetEmail(email.text.trim());

      UniFullScreenLoader.stopLoading();

      UniLoaders.successSnackBar(
          title: "Email Sent",
          message: "Email Link Sent to Reset your Password".tr);

      Get.to(() => ResetPasswordScreen(email: email.text.trim()));
    } catch (e) {
      UniFullScreenLoader.stopLoading();
      UniLoaders.errorSnackBar(title: "Oh Snap!", message: e.toString());
    }
  }

  resendPasswordResetEmail(String email) async {
    try {
      UniFullScreenLoader.openLoadingDialog("We are processing your request");

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        UniFullScreenLoader.stopLoading();
        return;
      }

      if (!forgetPasswordFormKey.currentState!.validate()) {
        UniFullScreenLoader.stopLoading();
        return;
      }

      await AuthenticationRepository.instance.sendPasssowrdResetEmail(email);

      UniFullScreenLoader.stopLoading();

      UniLoaders.successSnackBar(
          title: "Email Sent",
          message: "Email Link Sent to Reset your Password".tr);
    } catch (e) {
      UniFullScreenLoader.stopLoading();
      UniLoaders.errorSnackBar(title: "Oh Snap!", message: e.toString());
    }
  }
}
