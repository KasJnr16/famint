import 'package:fanmint/utility/constants/colors.dart';
import 'package:fanmint/utility/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:fanmint/view/login/sign_in_view.dart';
import 'package:fanmint/view/login/social_login.dart';
import 'package:get/get.dart';

import '../../common/color_extension.dart';
import '../../common_widget/secondary_boutton.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);
    final dark = HelperFunctions.isDarkMode(context);
    return Scaffold(
      backgroundColor: dark ? TColor.gray : UniColors.light,
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned.fill(
              child: Image.asset(
            "assets/img/login_background.png",
            fit: BoxFit.cover,
          )),
          Image.asset(
            "assets/img/app_logo_no_background.png",
            width: media.width * 0.7,
            color: dark ? UniColors.white : UniColors.primary,
            fit: BoxFit.cover,
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.5),
                  Text(
                    "Welcome to Fanmint, we help you manage your personal expenses",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.065,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.to(() => SocialLoginView());
                      },
                      child: Text("Get started"),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  SecondaryButton(
                    title: "I have an account",
                    onPressed: () {
                      Get.to(() => SignInView());
                    },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
