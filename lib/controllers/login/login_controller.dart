import 'package:fanmint/controllers/user/user_controller.dart';
import 'package:fanmint/repositories/authentication/authentication_repository.dart';
import 'package:fanmint/utility/device/network_manager.dart';
import 'package:fanmint/utility/logging/logger.dart';
import 'package:fanmint/utility/popups/fullscreen_loader.dart';
import 'package:fanmint/utility/popups/loaders.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();
  final userController = Get.put(UserController());

  //varsa
  final email = TextEditingController();
  final password = TextEditingController();

  final rememberMe = false.obs;
  final hidePassword = true.obs;

  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  //storage
  final localStorage = GetStorage();

  @override
  void onInit() {
    //auto load creds)
    if (localStorage.read("REMEMBER_ME_EMAIL") != null &&
        localStorage.read("REMEMBER_ME_PASSWORD") != null) {
      email.text = localStorage.read("REMEMBER_ME_EMAIL");
      password.text = localStorage.read("REMEMBER_ME_PASSWORD");
    }
    super.onInit();
  }

  emailAndPasswordlogin() async {
    try {
      //start loading
      UniFullScreenLoader.openLoadingDialog("Logging you in...");

      //check internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        UniFullScreenLoader.stopLoading();
        return;
      }

      //form validation
      if (!loginFormKey.currentState!.validate()) {
        UniFullScreenLoader.stopLoading();
        return;
      }
      //Check
      if (rememberMe.value) {
        localStorage.write("REMEMBER_ME_EMAIL", email.text.trim());
        localStorage.write("REMEMBER_ME_PASSWORD", password.text.trim());
      }

      //login user
      await AuthenticationRepository.instance
          .loginWithEmailAndPassword(email.text.trim(), password.text.trim());

      //Remove loader
      UserController.instance.fetchUserRecord();
      UniFullScreenLoader.stopLoading();

      //Redirect
      AuthenticationRepository.instance.screenRedirect();
    } catch (e) {
      UniFullScreenLoader.stopLoading();
      UniLoaders.errorSnackBar(title: "Oh Snap!", message: e.toString());
    }
  }

  //Google
  Future<void> googleSignIn() async {
    try {
      UniFullScreenLoader.openLoadingDialog("Logging you in with Google");

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        UniFullScreenLoader.stopLoading();
        return;
      }

      //Google Auth
      final userCredential =
          await AuthenticationRepository.instance.signInWithGoogle();

      //Save User
      await userController.saveUserRecord(userCredential);

      UniFullScreenLoader.stopLoading();

      AuthenticationRepository.instance.screenRedirect();
    } catch (e) {
      UniFullScreenLoader.stopLoading();
      UniLoaders.errorSnackBar(title: "Oh Snap!", message: "Login failed");
      UniLogger.error("Error", e);
    }
  }

  Future<void> resetAppDependenciesPreservingCore() async {
    UniLogger.info("Resetting userController...");
    userController.fetchUserRecord();
    UniLogger.info("userController reset successfully.");
  }
}
