import 'package:fanmint/utility/constants/colors.dart';
import 'package:fanmint/utility/constants/sizes.dart';
import 'package:fanmint/utility/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AboutPageView extends StatelessWidget {
  const AboutPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(UniSizes.defaultSpace),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                      onPressed: () => Get.back(),
                      color: HelperFunctions.isDarkMode(context)
                          ? UniColors.secondary
                          : UniColors.primary,
                      icon: Icon(Icons.arrow_back)),
                  Text(
                    "About us",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ],
              ),
              SizedBox(height: UniSizes.spaceBtwSections),
              Text(
                "Welcome to FANMINT– your partner in smarter money management.\n\n"
                "We believe financial freedom starts with simple daily habits. That’s why we created this tool: to help you track expenses, set goals, and stay on top of your finances with ease and confidence.\n\n"
                "Our mission is to make personal finance clear, secure, and accessible to everyone. Whether you’re budgeting for essentials, saving for a dream, or just trying to understand where your money goes, we’re here to guide you.\n\n"
                "🔒 Your Security, Our Priority\n"
                "We take your privacy seriously. All your data is encrypted and stored securely only you have access to it.\n\n"
                "💡 Our Vision\n"
                "We’re building more than an app; we’re creating a smarter way to handle money. Expect continuous updates, from AI-powered spending insights to better financial planning tools.\n\n"
                "🤝 Stay Connected\n"
                "Your feedback shapes our journey. If you have ideas or need support, reach us at support @ fanmint.com\n"
                "Together, let’s make money management simple.\n",
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
