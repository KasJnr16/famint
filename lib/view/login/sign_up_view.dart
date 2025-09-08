import 'package:fanmint/controllers/login/signup_controller.dart';
import 'package:fanmint/utility/constants/colors.dart';
import 'package:fanmint/utility/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fanmint/view/login/sign_in_view.dart';

import '../../common/color_extension.dart';
import '../../common_widget/round_textfield.dart';
import '../../common_widget/secondary_boutton.dart';

class SignUpView extends StatelessWidget {
  SignUpView({super.key});

  final signupController = Get.put(SignupController());
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
            child: SingleChildScrollView(
              child: Form(
                key: signupController.signupFormKey,
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
                      const SizedBox(height: 20),
                      Text(
                        "Hi, Newbie",
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      Text(
                        "Let's create a new account for you",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 20),

                      // Email Field
                      Row(
                        children: [
                          Expanded(
                            child: RoundTextField(
                              title: "First name",
                              controller: signupController.firstName,
                              keyboardType: TextInputType.text,
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: RoundTextField(
                              title: "Last name",
                              controller: signupController.lastName,
                              keyboardType: TextInputType.text,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      RoundTextField(
                        title: "Email",
                        controller: signupController.email,
                        keyboardType: TextInputType.emailAddress,
                      ),

                      const SizedBox(height: 15),

                      // Password Field
                      Obx(() => RoundTextField(
                            title: "Password",
                            controller: signupController.password,
                            obscureText: signupController.hidePassword.value,
                            suffixIcon: IconButton(
                              icon: Icon(
                                signupController.hidePassword.value
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: TColor.gray50,
                              ),
                              onPressed: () {
                                signupController.hidePassword.toggle();
                              },
                            ),
                          )),
                      const SizedBox(height: 20),

                      // Password strength rule
                      Row(
                        children: List.generate(
                          4,
                          (_) => Expanded(
                            child: Container(
                              height: 5,
                              margin: const EdgeInsets.symmetric(horizontal: 1),
                              decoration: BoxDecoration(
                                color: dark ? TColor.gray70 : UniColors.light,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Use 8 or more characters with a mix of letters,\nnumbers & symbols.",
                            style:
                                TextStyle(color: TColor.gray50, fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Submit
                      SizedBox(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.065,
                        child: ElevatedButton(
                          onPressed: () {
                            signupController.signup();
                          },
                          child: Text("Get started, it's free!"),
                        ),
                      ),

                      const SizedBox(height: 20),
                      Text(
                        "Do you already have an account?",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 20),
                      SecondaryButton(
                        title: "Sign in",
                        onPressed: () {
                          Get.offAll(() => SignInView());
                        },
                      ),
                      const SizedBox(height: 20), // Extra padding bottom
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
