import 'package:fanmint/common_widget/circular_image.dart';
import 'package:fanmint/common_widget/shimmer.dart';
import 'package:fanmint/controllers/user/user_controller.dart';
import 'package:fanmint/utility/constants/colors.dart';
import 'package:fanmint/utility/constants/sizes.dart';
import 'package:fanmint/utility/helpers/helper_functions.dart';
import 'package:fanmint/utility/logging/logger.dart';
import 'package:fanmint/utility/popups/loaders.dart';
import 'package:fanmint/utility/theme/theme_provider.dart';
import 'package:fanmint/view/profile/profile_view.dart';
import 'package:fanmint/view/settings/about_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';

import '../../common/color_extension.dart';
import '../../common_widget/icon_item_row.dart';

class SettingsController extends GetxController {
  RxBool isActive = false.obs;
  final RxBool isBiometricSupported = false.obs;
  final LocalAuthentication auth = LocalAuthentication();

  @override
  void onInit() {
    super.onInit();
    checkBiometricSupport();
  }

  void toggleSync(bool value) => isActive.value = value;

  /// Check if device supports biometrics
  Future<void> checkBiometricSupport() async {
    try {
      final supported = await auth.isDeviceSupported();
      isBiometricSupported.value = supported;
    } catch (e) {
      UniLogger.error("Biometric Support Error", e.toString());
      isBiometricSupported.value = false;
    }
  }

  /// Trigger biometric authentication
  Future<void> authenticateWithBiometrics() async {
    try {
      final bool authenticated = await auth.authenticate(
        localizedReason: "This is required to make your app more secure.",
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
        ),
      );

      UniLogger.info("Authenticated: $authenticated");
      if (!authenticated) {
        UniLoaders.warningSnackBar(
          title: "Authentication Failed",
          message: "Please try again.",
        );
      }
    } on PlatformException catch (e) {
      UniLoaders.errorSnackBar(
        title: "Authentication Error",
        message: "Problem authenticating user.",
      );
      UniLogger.error("Biometric Error", e.toString());
    }
  }
}

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SettingsController());
    final dark = HelperFunctions.isDarkMode(context);
    final userController = Get.find<UserController>();

    return Scaffold(
      backgroundColor: dark ? TColor.gray : UniColors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(UniSizes.defaultSpace),
            child: Column(children: [
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
                    "Settings",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Obx(
                () {
                  final networkImage =
                      userController.currentUser.value.profilePicture;
                  final image = networkImage.isNotEmpty
                      ? networkImage
                      : "assets/img/u1.png";

                  return userController.imageUploading.value
                      ? const UniShimmerEffect(
                          width: 70, height: 60, radius: 50)
                      : UniCircularImage(
                          padding: 0,
                          isNetworkImage: networkImage.isNotEmpty,
                          imageUrl: image,
                          width: 70,
                          height: 70,
                        );
                },
              ),
              const SizedBox(height: UniSizes.spaceBtwItems),
              Obx(() => userController.profileLoading.value
                  ? UniShimmerEffect(width: 100, height: 20)
                  : Text(
                      userController.currentUser.value.fullname,
                      style: Theme.of(context).textTheme.titleLarge,
                    )),
              const SizedBox(height: 4),
              Obx(
                () => userController.profileLoading.value
                    ? UniShimmerEffect(width: 120, height: 15)
                    : Text(userController.currentUser.value.email,
                        style: Theme.of(context).textTheme.labelLarge),
              ),
              const SizedBox(height: UniSizes.spaceBtwItems),
              TextButton(
                onPressed: () => Get.to(() => ProfileView()),
                child: Text("Edit Profile"),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle("General"),
                  _settingContainer(dark, [
                    IconItemRow(
                      onPressed: () {
                        if (controller.isBiometricSupported.value) {
                          controller.authenticateWithBiometrics();
                        } else {
                          UniLoaders.warningSnackBar(
                            message: "Your device doesn't support biometrics",
                          );
                        }
                      },
                      title: "Security",
                      icon: "assets/img/face_id.png",
                      value: "Biometrics",
                    ),
                  ]),
                  _sectionTitle("Appearance"),
                  _settingContainer(
                    dark,
                    [
                      IconItemSwitchRow(
                        title: "Theme",
                        icon: "assets/img/light_theme.png",
                        value: Provider.of<UniThemeProvider>(context,
                                listen: false)
                            .isDarkMode,
                        didChange: (value) => Provider.of<UniThemeProvider>(
                                context,
                                listen: false)
                            .toggleTheme(),
                      ),
                    ],
                  ),
                  _sectionTitle("About"),
                  _settingContainer(
                    dark,
                    [
                      IconItemRow(
                        onPressed: () {
                          Get.to(() => AboutPageView());
                        },
                        title: "Information",
                        icon: "assets/img/face_id.png",
                        value: "view",
                      ),
                    ],
                  ),
                  SizedBox(
                    height: UniSizes.spaceBtwItems,
                  ),
                ],
              )
            ]),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(UniSizes.defaultSpace),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
              onPressed: userController.logoutWarningPopUp,
              child: Text("Log out")),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) => Padding(
        padding: const EdgeInsets.only(top: 15, bottom: 8),
        child: Text(title,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
      );

  Widget _settingContainer(bool dark, List<Widget> children) => Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: TColor.border.withOpacity(0.1)),
          color:
              dark ? TColor.gray60.withOpacity(0.2) : UniColors.lightContainer,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(children: children),
      );
}
