import 'package:fanmint/common_widget/circular_image.dart';
import 'package:fanmint/common_widget/section_heading.dart';
import 'package:fanmint/common_widget/shimmer.dart';
import 'package:fanmint/controllers/user/update_user_info_controller.dart';
import 'package:fanmint/controllers/user/user_controller.dart';
import 'package:fanmint/utility/constants/colors.dart';
import 'package:fanmint/utility/constants/sizes.dart';
import 'package:fanmint/utility/formatters/formatters.dart';
import 'package:fanmint/utility/helpers/helper_functions.dart';
import 'package:fanmint/view/profile/widget/change_addition_info.dart';
import 'package:fanmint/view/profile/widget/change_name.dart';
import 'package:fanmint/view/profile/widget/profile_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;
    final updateController = Get.put(UpdateUserInfoController());

    return Scaffold(
      //body
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(UniSizes.defaultSpace),
          child: Column(
            children: [
              //Profile Picture
              SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    //header
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
                          "Profile",
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: UniSizes.spaceBtwSections),
                    Obx(() {
                      final networkImage =
                          controller.currentUser.value.profilePicture;
                      final image = networkImage.isNotEmpty
                          ? networkImage
                          : "assets/img/u1.png";

                      return controller.imageUploading.value
                          ? const UniShimmerEffect(
                              width: 80,
                              height: 80,
                              radius: 80,
                            )
                          : UniCircularImage(
                              isNetworkImage: networkImage.isNotEmpty,
                              imageUrl: image,
                              width: 80,
                              height: 80,
                            );
                    }),
                    TextButton(
                      onPressed: () => controller.uploadUserProfilePicture(),
                      child: const Text(
                        "Change Profile Picture",
                        style: TextStyle(fontSize: UniSizes.fontSizeMd),
                      ),
                    ),
                  ],
                ),
              ),

              //Details
              const SizedBox(height: UniSizes.spaceBtwItems / 2),
              const Divider(),
              const SizedBox(height: UniSizes.spaceBtwItems),

              //Heading Profile info
              const UniSectionHeading(
                title: "Profile Information",
                showActionButton: false,
              ),
              const SizedBox(height: UniSizes.spaceBtwItems),

              ProfileMenu(
                title: "Name",
                value: controller.currentUser.value.fullname,
                onPressed: () => Get.to(() => const ChangeNameScreen()),
              ),

              // ProfileMenu(
              //   title: "Username",
              //   value: controller.currentUser.value.username,
              //   onPressed: () => Get.to(
              //     () => ChangeAdditionInfo(
              //       title: "Change Username",
              //       fieldName: "Username",
              //       textController: updateController.username,
              //       labelText: "Username",
              //     ),
              //   ),
              // ),

              const SizedBox(height: UniSizes.spaceBtwItems),
              const Divider(),
              const SizedBox(height: UniSizes.spaceBtwItems),

              //Heading Personal info
              const UniSectionHeading(
                title: "Personal Information",
                showActionButton: false,
              ),
              const SizedBox(height: UniSizes.spaceBtwItems),

              // ProfileMenu(
              //   title: "UserID",
              //   value: controller.currentUser.value.id,
              //   icon: Iconsax.copy,
              //   onPressed: () {
              //     Clipboard.setData(
              //       ClipboardData(text: controller.currentUser.value.id),
              //     );
              //     UniLoaders.successSnackBar(
              //       title: "Copied!",
              //       message: "User ID copied to clipboard",
              //     );
              //   },
              // ),
              ProfileMenu(
                title: "Email",
                value: controller.currentUser.value.email,
                onPressed: () => Get.to(
                  () => ChangeAdditionInfo(
                    title: "Change Email",
                    fieldName: "Email",
                    textController: updateController.email,
                    labelText: "Email",
                  ),
                ),
              ),
              ProfileMenu(
                title: "Phone Number",
                value: Formatters.formatPhoneNumber(
                  controller.currentUser.value.phoneNumber,
                ),
                onPressed: () => Get.to(
                  () => ChangeAdditionInfo(
                    title: "Change Phone Number",
                    fieldName: "PhoneNumber",
                    textController: updateController.phoneNumber,
                    labelText: "Phone Number",
                  ),
                ),
              ),

              const Divider(),
              const SizedBox(height: UniSizes.spaceBtwItems),

              //Btn to delete account
              Center(
                child: TextButton(
                  onPressed: () => controller.deleteAccountWarningPopup(),
                  child: const Text(
                    "Close Account",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: UniSizes.fontSizeMd,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
