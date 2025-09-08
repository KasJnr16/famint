import 'package:fanmint/repositories/user/user_repository.dart';
import 'package:fanmint/utility/exceptions/custom_exceptions.dart';
import 'package:fanmint/utility/local_storage/storage_utility.dart';
import 'package:fanmint/utility/popups/loaders.dart';
import 'package:fanmint/view/login/sign_in_view.dart';
import 'package:fanmint/view/login/social_login.dart';
import 'package:fanmint/view/login/verify_email.dart';
import 'package:fanmint/view/login/welcome_view.dart';
import 'package:fanmint/view/main_tab/main_tab_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  //vars
  final deviceStorage = GetStorage();
  final _auth = FirebaseAuth.instance;
  User? get authUser => _auth.currentUser;

  //called from main on app lunch
  @override
  void onReady() {
    FlutterNativeSplash.remove();
    screenRedirect();
  }

  //function to show Relevant screen
  screenRedirect() async {
    //get user
    final user = _auth.currentUser;

    if (user != null) {
      //checks if user email is verified
      if (user.emailVerified) {
        //initialize user specific storage
        //the user uid is the bucket name
        //goto main page
        await UniLocalStorage.init(user.uid);
        Get.off(() => MainTabView());
      } else {
        Get.offAll(() => VerifyEmailScreen(email: _auth.currentUser?.email));
      }
    } else {
      //Using local Storage
      deviceStorage.writeIfNull("isFirstTime", true);

      //checks for first time users
      deviceStorage.read("isFirstTime") != true
          ? Get.offAll(() => SocialLoginView())
          : Get.offAll(() => const WelcomeView());
    }
  }
  /*-------------------Email and Password sign up-----------------------*/

  //register
  Future<UserCredential> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw UniFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw UniFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw UniFormatException(code: "Invalid_format").message;
    } on PlatformException catch (e) {
      throw UniPlatformException(e.code).message;
    } catch (e) {
      rethrow;
    }
  }

  //Email Verification
  Future<void> sendEmailVerification() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw UniFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw UniFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw UniFormatException(code: "Invalid_format").message;
    } on PlatformException catch (e) {
      throw UniPlatformException(e.code).message;
    } catch (e) {
      rethrow;
    }
  }

  /*--------------------Social Sigin------------------*/
  Future<UserCredential> signInWithGoogle() async {
    try {
      //Popup to select account
      final GoogleSignInAccount? userAccount = await GoogleSignIn().signIn();

      //Obtain details
      final GoogleSignInAuthentication? googleAuth =
          await userAccount?.authentication;

      //create a new credentials
      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);

      //return credentials
      return await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw UniFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw UniFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw UniFormatException(code: "Invalid_format").message;
    } on PlatformException catch (e) {
      throw UniPlatformException(e.code).message;
    } catch (e) {
      rethrow;
    }
  }

  /*-------------------Sign in-----------------------*/

  Future<UserCredential> loginWithEmailAndPassword(
      String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw UniFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw UniFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw UniFormatException(code: "Invalid_format").message;
    } on PlatformException catch (e) {
      throw UniPlatformException(e.code).message;
    } catch (e) {
      rethrow;
    }
  }

  /*-------------------Log out----------------------*/

  //logout
  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Get.offAll(() => SignInView());
    } on FirebaseAuthException catch (e) {
      throw UniFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw UniFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw UniFormatException(code: "Invalid_format").message;
    } on PlatformException catch (e) {
      throw UniPlatformException(e.code).message;
    } catch (e) {
      rethrow;
    }
  }

  /*-------------------Management---------------------*/

  Future<void> linkGoogleAccount() async {
    bool isGoogleLinked = authUser!.providerData
        .any((info) => info.providerId == GoogleAuthProvider.PROVIDER_ID);
    if (isGoogleLinked) {
      UniLoaders.warningSnackBar(message: "Google account is already linked.");
      return;
    }

    try {
      final GoogleSignInAccount? userAccount = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth =
          await userAccount!.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await authUser!.linkWithCredential(credential);
      UniLoaders.successSnackBar(
          message: "Google account linked successfully!");
    } on FirebaseAuthException catch (e) {
      throw UniFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw UniFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw UniFormatException(code: "Invalid_format").message;
    } on PlatformException catch (e) {
      throw UniPlatformException(e.code).message;
    } catch (e) {
      UniLoaders.errorSnackBar(
          title: "Link Account Error",
          message: "Error linking Google account: $e");
    }
  }

  //Reset Password
  Future<void> sendPasssowrdResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw UniFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw UniFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw UniFormatException(code: "Invalid_format").message;
    } on PlatformException catch (e) {
      throw UniPlatformException(e.code).message;
    } catch (e) {
      rethrow;
    }
  }

  //delete user
  Future<void> deleteAccount() async {
    try {
      //Remove user data from db
      await UserRepository.instance.removeUserRecord(_auth.currentUser!.uid);
      //Remove user from app
      await _auth.currentUser?.delete();
    } on FirebaseAuthException catch (e) {
      throw UniFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw UniFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw UniFormatException(code: "Invalid_format").message;
    } on PlatformException catch (e) {
      throw UniPlatformException(e.code).message;
    } catch (e) {
      rethrow;
    }
  }

  //ReAuthenticate User
  Future<void> reAuthenticateEmailAndPasswordUser(
      String email, String password) async {
    try {
      //create a credential
      AuthCredential credential =
          EmailAuthProvider.credential(email: email, password: password);
      //reAuth
      await _auth.currentUser!.reauthenticateWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw UniFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw UniFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw UniFormatException(code: "Invalid_format").message;
    } on PlatformException catch (e) {
      throw UniPlatformException(e.code).message;
    } catch (e) {
      rethrow;
    }
  }
}
