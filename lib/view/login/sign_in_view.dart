import 'package:fanmint/controllers/login/login_controller.dart';
import 'package:fanmint/utility/constants/colors.dart';
import 'package:fanmint/utility/constants/sizes.dart';
import 'package:fanmint/utility/helpers/helper_functions.dart';
import 'package:fanmint/view/login/password_config/forget_password.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fanmint/view/login/sign_up_view.dart';

import '../../common/color_extension.dart';
import '../../common_widget/round_textfield.dart';
import '../../common_widget/secondary_boutton.dart';

class SignInView extends StatelessWidget {
  SignInView({super.key});

  final loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);
    final dark = HelperFunctions.isDarkMode(context);

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
              child: Image.asset(
            "assets/img/login_background.png",
            fit: BoxFit.cover,
          )),
          SafeArea(
            child: Form(
              key: loginController.loginFormKey,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/img/app_logo_no_background.png",
                      color: dark ? UniColors.white : UniColors.primary,
                      width: media.width * 0.5,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: UniSizes.spaceBtwItems),
                    Text(
                      "Welcome Back!",
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    Text(
                      "Use your money wisely, always!",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),

                    SizedBox(height: UniSizes.spaceBtwSections),
                    // Email Field
                    RoundTextField(
                      title: "Email",
                      controller: loginController.email,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 15),

                    // Password Field
                    Obx(() => RoundTextField(
                          title: "Password",
                          controller: loginController.password,
                          obscureText: loginController.hidePassword.value,
                          suffixIcon: IconButton(
                            icon: Icon(
                              loginController.hidePassword.value
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: TColor.gray50,
                            ),
                            onPressed: () {
                              loginController.hidePassword.toggle();
                            },
                          ),
                        )),

                    const SizedBox(height: 8),

                    // Remember me & Forgot Password
                    Obx(() => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () {
                                loginController.rememberMe.toggle();
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    loginController.rememberMe.value
                                        ? Icons.check_box_rounded
                                        : Icons.check_box_outline_blank_rounded,
                                    size: 25,
                                    color: TColor.gray50,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Remember me",
                                    style: TextStyle(
                                        color: TColor.gray50, fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed: () =>
                                  Get.to(() => const ForgetPassword()),
                              child: Text(
                                "Forgot password",
                                style: TextStyle(
                                    color: TColor.gray50, fontSize: 14),
                              ),
                            ),
                          ],
                        )),

                    const SizedBox(height: 8),

                    // Sign In Button
                    SizedBox(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.07,
                      child: ElevatedButton(
                        onPressed: () {
                          loginController.emailAndPasswordlogin();
                        },
                        child: Text("Sign in"),
                      ),
                    ),

                    Spacer(),

                    // Sign Up
                    Padding(
                      padding: const EdgeInsets.all(UniSizes.defaultSpace),
                      child: SecondaryButton(
                        title: "Sign up",
                        onPressed: () {
                          Get.offAll(() => SignUpView());
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
