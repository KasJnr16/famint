import 'package:fanmint/controllers/user/user_controller.dart';
import 'package:fanmint/repositories/user/user_repository.dart';
import 'package:fanmint/utility/device/network_manager.dart';
import 'package:fanmint/utility/popups/fullscreen_loader.dart';
import 'package:fanmint/utility/popups/loaders.dart';
import 'package:fanmint/view/profile/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateUserInfoController extends GetxController {
  static UpdateUserInfoController get instance => Get.find();

  final email = TextEditingController();
  final phoneNumber = TextEditingController();
  final username = TextEditingController();
  GlobalKey<FormState> updateUserInfoFormKey = GlobalKey<FormState>();

  final userRepository = UserRepository.instance;
  final userController = UserController.instance;

  @override
  void onInit() {
    initializeFields();
    super.onInit();
  }

  Future<void> initializeFields() async {
    email.text = userController.currentUser.value.email;
    phoneNumber.text = userController.currentUser.value.phoneNumber;
    username.text = userController.currentUser.value.username;
  }

  Future<void> updateUserInfo(
    String fieldName,
    TextEditingController controller,
  ) async {
    try {
      UniFullScreenLoader.openLoadingDialog(
        "We are updating your Information...",
      );

      //check internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        UniFullScreenLoader.stopLoading();
        return;
      }

      //form validation
      if (!updateUserInfoFormKey.currentState!.validate()) {
        UniFullScreenLoader.stopLoading();
        return;
      }

      Map<String, dynamic> info = {fieldName: controller.text.trim()};
      await userRepository.updateUserSingleField(info);

      // Dynamically update the Rx user field
      userController.currentUser.update((user) {
        if (user != null) {
          user.setFieldValue(fieldName, controller.text.trim());
        }
      });

      UniFullScreenLoader.stopLoading();

      UniLoaders.successSnackBar(
        title: "Congratulations",
        message: "Your $fieldName has been updated.",
      );

      Get.off(() => const ProfileView());
    } catch (e) {
      UniFullScreenLoader.stopLoading();
      UniLoaders.errorSnackBar(title: "Oh Snap!", message: e.toString());
    }
  }
}
