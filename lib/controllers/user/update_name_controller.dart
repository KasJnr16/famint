import 'package:fanmint/controllers/user/user_controller.dart';
import 'package:fanmint/repositories/user/user_repository.dart';
import 'package:fanmint/utility/device/network_manager.dart';
import 'package:fanmint/utility/popups/fullscreen_loader.dart';
import 'package:fanmint/utility/popups/loaders.dart';
import 'package:fanmint/view/profile/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateNameController extends GetxController {
  static UpdateNameController get instance => Get.find();

  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final userRepository = UserRepository.instance;
  final userController = Get.put(UserController());
  GlobalKey<FormState> updateUserNameFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    initializeNames();
    super.onInit();
  }

  Future<void> initializeNames() async {
    firstName.text = userController.currentUser.value.firstName;
    lastName.text = userController.currentUser.value.lastName;
  }

  Future<void> updateUserName() async {
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
      if (!updateUserNameFormKey.currentState!.validate()) {
        UniFullScreenLoader.stopLoading();
        return;
      }

      Map<String, dynamic> name = {
        "FirstName": firstName.text.trim(),
        "LastName": lastName.text.trim(),
      };
      await userRepository.updateUserSingleField(name);

      //update the Rx User value
      userController.currentUser.value.firstName = firstName.text.trim();
      userController.currentUser.value.lastName = lastName.text.trim();

      UniFullScreenLoader.stopLoading();

      UniLoaders.successSnackBar(
        title: "Congratulations",
        message: "Your Name has been updated.",
      );

      Get.off(() => const ProfileView());
    } catch (e) {
      UniFullScreenLoader.stopLoading();
      UniLoaders.errorSnackBar(title: "Oh Snap!", message: e.toString());
    }
  }
}
