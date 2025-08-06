import 'package:fanmint/controllers/login/re_authenticate_user_login_form.dart';
import 'package:fanmint/models/user_model.dart';
import 'package:fanmint/repositories/authentication/authentication_repository.dart';
import 'package:fanmint/repositories/user/user_repository.dart';
import 'package:fanmint/utility/constants/enums.dart';
import 'package:fanmint/utility/constants/sizes.dart';
import 'package:fanmint/utility/device/network_manager.dart';
import 'package:fanmint/utility/popups/fullscreen_loader.dart';
import 'package:fanmint/utility/popups/loaders.dart';
import 'package:fanmint/view/login/sign_in_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();

  final userRepository = UserRepository.instance;

  final hidePassword = false.obs;
  final imageUploading = false.obs;
  final profileLoading = false.obs;
  Rx<UserModel> currentUser = UserModel.empty().obs;
  Rx<UserModel> otherUser = UserModel.empty().obs;

  final verifyEmail = TextEditingController();
  final verifyPassword = TextEditingController();
  GlobalKey<FormState> reAuthFormKey = GlobalKey<FormState>();

  final _authRepo = AuthenticationRepository.instance;
  final deviceStorage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    fetchUserRecord();
  }

  //get user
  Future<void> fetchUserRecord() async {
    try {
      profileLoading.value = true;
      final user = await userRepository.fetchUserDetails();
      currentUser(user);
    } catch (e) {
      currentUser(UserModel.empty());
    } finally {
      profileLoading.value = false;
    }
  }

  //save user
  Future<void> saveUserRecord(UserCredential? userCredentials) async {
    try {
      //Refresh user recall
      await fetchUserRecord();

      if (currentUser.value.id.isEmpty) {
        if (userCredentials != null) {
          //Extracting user info
          final nameParts =
              UserModel.nameParts(userCredentials.user!.displayName ?? "");

          final username = UserModel.generateUsername(
              userCredentials.user!.displayName ?? "");

          //Map Data
          final user = UserModel(
            id: userCredentials.user!.uid,
            firstName: nameParts[0],
            lastName:
                nameParts.length > 1 ? nameParts.sublist(1).join(" ") : "",
            username: username,
            email: userCredentials.user!.email ?? "",
            phoneNumber: userCredentials.user!.phoneNumber ?? "",
            gender: "",
            role: UserRole.client.name,
            profilePicture: userCredentials.user!.photoURL ?? "",
          );

          //save user data
          await userRepository.saveUserRecord(user);
        }
      }
    } catch (e) {
      UniLoaders.warningSnackBar(
        title: "Data not saved",
        message:
            "Something went wrong while saving your information. Please try again.",
      );
    }
  }

  //Delete Account Warning
  void deleteAccountWarningPopup() {
    Get.defaultDialog(
      contentPadding: const EdgeInsets.all(UniSizes.defaultSpace),
      title: "Delete Account",
      content: Column(
        children: [
          Text(
            "Are you sure you want to delete your account permanently? This action is not reversible.",
          ),
          SizedBox(height: UniSizes.spaceBtwSections),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => Navigator.of(Get.overlayContext!).pop(),
              child: const Text("Cancel"),
            ),
          ),
          SizedBox(height: UniSizes.spaceBtwItems),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async => deleteUserAccount(),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red)),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: UniSizes.lg),
                child: Text("Delete"),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void logoutWarningPopUp() {
    Get.defaultDialog(
      contentPadding: const EdgeInsets.all(UniSizes.md),
      title: "Logout Account",
      middleText: "Are you sure you want to logout your account?",
      confirm: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () async {
            _authRepo.logout();
          },
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: UniSizes.lg),
            child: Text("Logout"),
          ),
        ),
      ),
      cancel: SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          onPressed: () => Navigator.of(Get.overlayContext!).pop(),
          child: const Text("Cancel"),
        ),
      ),
    );
  }

  //Delete User Account
  Future<void> deleteUserAccount() async {
    try {
      UniFullScreenLoader.openLoadingDialog("Processing...");

      final provider =
          _authRepo.authUser!.providerData.map((e) => e.providerId).first;

      if (provider.isNotEmpty) {
        //re verify
        if (provider == "google.com") {
          await _authRepo.signInWithGoogle();
          await _authRepo.deleteAccount();
          UniFullScreenLoader.stopLoading();
          Get.offAll(() => SignInView());
        } else if (provider == 'password') {
          UniFullScreenLoader.stopLoading();
          Get.to(() => const ReAuthLoginForm());
        }
      }
    } catch (e) {
      UniFullScreenLoader.stopLoading();
      UniLoaders.warningSnackBar(title: "Oh Snap!", message: e.toString());
    }
  }

  //reAuthUser
  Future<void> reAuthenticateEmailAndPasswordUser() async {
    try {
      UniFullScreenLoader.openLoadingDialog(
        "Processing...",
      );

      //check internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        UniFullScreenLoader.stopLoading();
        return;
      }

      if (!reAuthFormKey.currentState!.validate()) {
        UniFullScreenLoader.stopLoading();
        return;
      }

      await _authRepo.reAuthenticateEmailAndPasswordUser(
          verifyEmail.text.trim(), verifyPassword.text.trim());
      await _authRepo.deleteAccount();

      UniFullScreenLoader.stopLoading();
      Get.offAll(() => SignInView());
    } catch (e) {
      UniFullScreenLoader.stopLoading();
      UniLoaders.warningSnackBar(title: "Oh Snap!", message: e.toString());
    }
  }

  //Upload Profile Picture
  uploadUserProfilePicture() async {
    try {
      final image = await ImagePicker().pickImage(
          source: ImageSource.gallery,
          imageQuality: 70,
          maxHeight: 512,
          maxWidth: 512);

      if (image != null) {
        imageUploading.value = true;
        //upload image and return path
        final imageUrl =
            await userRepository.uploadImage("Users/Images/Profile/", image);

        //update userRecord
        Map<String, dynamic> json = {"ProfilePicture": imageUrl};
        await userRepository.updateUserSingleField(json);

        //passing data to Rx<UserModel>
        currentUser.value.profilePicture = imageUrl;
        currentUser.refresh();

        UniLoaders.successSnackBar(
            title: "Congratulations",
            message: "Your Profile Image has been updated!");
      }
    } catch (e) {
      UniLoaders.warningSnackBar(title: "Oh Snap!", message: e.toString());
    } finally {
      imageUploading.value = false;
    }
  }

  Future<void> fetchUserById(String userID) async {
    if (otherUser.value.id == userID && otherUser.value.id.isNotEmpty) return;
    try {
      profileLoading.value = true;
      final user = await UserRepository.instance.fetchUserById(userID);
      otherUser(user);
    } catch (e) {
      otherUser.value = UserModel.empty();
    } finally {
      profileLoading.value = false;
    }
  }
}
