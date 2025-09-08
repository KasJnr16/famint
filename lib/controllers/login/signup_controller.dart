import 'package:fanmint/models/user_model.dart';
import 'package:fanmint/repositories/authentication/authentication_repository.dart';
import 'package:fanmint/repositories/user/user_repository.dart';
import 'package:fanmint/utility/constants/enums.dart';
import 'package:fanmint/utility/device/network_manager.dart';
import 'package:fanmint/utility/logging/logger.dart';
import 'package:fanmint/utility/popups/fullscreen_loader.dart';
import 'package:fanmint/utility/popups/loaders.dart';
import 'package:fanmint/view/login/verify_email.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  static SignupController get instance => Get.find();
  //text
  final email = TextEditingController();
  final username = TextEditingController();
  final lastName = TextEditingController();
  final firstName = TextEditingController();
  final password = TextEditingController();
  final phoneNumber = TextEditingController();

  //obx var
  final hidePassword = true.obs;
  final privacyPolicy = true.obs;
  var selectedGender = Rx<String?>(null);

  GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();

  signup() async {
    try {
      //start loading
      UniFullScreenLoader.openLoadingDialog(
          "We are processing your Information...");

      //check internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        UniFullScreenLoader.stopLoading();
        return;
      }

      //form validation
      if (!signupFormKey.currentState!.validate()) {
        UniFullScreenLoader.stopLoading();
        return;
      }

      //Privacy check
      if (!privacyPolicy.value) {
        UniLoaders.warningSnackBar(
            title: "Accept Privavcy Policy",
            message:
                "In order to create an account, you must have read and accepted the Privacy Policy & Terms of Use.");
        UniFullScreenLoader.stopLoading();
        return;
      }

      //Register user
      final userCredentials = await AuthenticationRepository.instance
          .registerWithEmailAndPassword(
              email.text.trim(), password.text.trim());

      final username =
          UserModel.generateUsername(userCredentials.user!.displayName ?? "");

      //Save auth user data in firestore
      final newUser = UserModel(
        id: userCredentials.user!.uid,
        firstName: firstName.text.trim(),
        lastName: lastName.text.trim(),
        username: username,
        email: email.text.trim(),
        phoneNumber: phoneNumber.text.trim(),
        role: UserRole.client.name,
        gender: "",
        profilePicture: userCredentials.user!.photoURL ?? "",
      );

      final userRepository = UserRepository.instance;
      await userRepository.saveUserRecord(newUser);

      //Show success screen
      UniLoaders.successSnackBar(
        title: "Congratulations",
        message: "Your account has been created! Verify email to continue.",
      );

      //Move to verify Email
      Get.to(() => VerifyEmailScreen(email: email.text.trim()));
    } catch (e) {
      //Remove loader
      UniFullScreenLoader.stopLoading();

      //show error
      UniLoaders.errorSnackBar(title: "Oh Snap!", message: e.toString());
      UniLogger.error("Signin Error", e.toString());
    }
  }
}
