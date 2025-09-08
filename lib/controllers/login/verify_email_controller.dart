import 'dart:async';
import 'package:fanmint/common_widget/success_screen.dart';
import 'package:fanmint/repositories/authentication/authentication_repository.dart';
import 'package:fanmint/utility/constants/image_strings.dart';
import 'package:fanmint/utility/constants/text_string.dart';
import 'package:fanmint/utility/popups/loaders.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class VerifyEmailController extends GetxController {
  static VerifyEmailController get instance => Get.find();
  Timer? timer;

  //Send Email Automatically when screen is launched
  @override
  void onInit() {
    sendEmailVerification();

    try {
      setTimerForAutoRedirect();
    } catch (e) {
      timer?.cancel();
      if (kDebugMode) {
        print(e.toString());
      }
      return;
    }

    super.onInit();
  }

  //Send Email Verification link
  void sendEmailVerification() async {
    try {
      await AuthenticationRepository.instance.sendEmailVerification();
      UniLoaders.successSnackBar(
          title: "Email sent",
          message: "Please check your inbox and verify your email.");
    } catch (e) {
      UniLoaders.errorSnackBar(title: "oh Snap!", message: e.toString());
    }
  }

  void setTimerForAutoRedirect() {
    try {
      timer = Timer.periodic(
        const Duration(seconds: 1),
        (timer) async {
          //Checks____
          await FirebaseAuth.instance.currentUser?.reload();
          final user = FirebaseAuth.instance.currentUser;

          if (user?.emailVerified ?? false) {
            timer.cancel();
            Get.off(
              () => SuccessScreen(
                image: UniImages.succesful,
                title: UniTexts.yourAccountCreatedSubTitle,
                subtitle: UniTexts.yourAccountCreatedTitle,
                onPressed: () =>
                    AuthenticationRepository.instance.screenRedirect(),
              ),
            );
          }
        },
      );
    } on Exception catch (e) {
      UniLoaders.errorSnackBar(title: "Login Error", message: e.toString());
    }
  }

  //Manually Check if Email Verified
  void checkEmailVerificationStatus() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null && currentUser.emailVerified) {
      Get.off(
        () => SuccessScreen(
          image: UniImages.succesful,
          title: UniTexts.yourAccountCreatedSubTitle,
          subtitle: UniTexts.yourAccountCreatedTitle,
          onPressed: () => AuthenticationRepository.instance.screenRedirect(),
        ),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
