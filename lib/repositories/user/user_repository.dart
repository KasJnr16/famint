import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fanmint/models/user_model.dart';
import 'package:fanmint/repositories/authentication/authentication_repository.dart';
import 'package:fanmint/utility/exceptions/custom_exceptions.dart';
import 'package:fanmint/utility/logging/logger.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final _authRepository = AuthenticationRepository.instance;

  //save user
  Future<void> saveUserRecord(UserModel user) async {
    try {
      await _db.collection("Users").doc(user.id).set(user.toJson());
    } on FirebaseException catch (e) {
      throw UniFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw UniFormatException(code: "Invalid_format").message;
    } on PlatformException catch (e) {
      throw UniPlatformException(e.code).message;
    } catch (e) {
      UniLogger.error("userRepo: $e");
      throw "Someting went wrong, Please try again";
    }
  }

  Future<UserModel> fetchUserDetails() async {
    try {
      final documentSnapshot = await _db
          .collection("Users")
          .doc(_authRepository.authUser?.uid)
          .get();
      if (documentSnapshot.exists) {
        return UserModel.fromSnapshot(documentSnapshot);
      } else {
        return UserModel.empty();
      }
    } on FirebaseException catch (e) {
      throw UniFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw UniFormatException(code: "Invalid_format").message;
    } on PlatformException catch (e) {
      throw UniPlatformException(e.code).message;
    } catch (e) {
      UniLogger.error("userRepo: $e");
      throw "Someting went wrong, Please try again";
    }
  }

  Future<UserModel> fetchUserById(String userID) async {
    try {
      final documentSnapshot = await _db.collection("Users").doc(userID).get();

      if (documentSnapshot.exists) {
        return UserModel.fromSnapshot(documentSnapshot);
      } else {
        return UserModel.empty();
      }
    } on FirebaseException catch (e) {
      throw UniFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw UniFormatException(code: "Invalid_format").message;
    } on PlatformException catch (e) {
      throw UniPlatformException(e.code).message;
    } catch (e) {
      UniLogger.error("userRepo: $e");
      throw "Someting went wrong, Please try again";
    }
  }

  Future<List<UserModel>> fetchUsers() async {
    try {
      final snapshot = await _db.collection("Users").get();

      return snapshot.docs
          .map((document) => UserModel.fromSnapshot(document))
          .toList();
    } on FirebaseException catch (e) {
      throw UniFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw UniFormatException(code: "Invalid_format").message;
    } on PlatformException catch (e) {
      throw UniPlatformException(e.code).message;
    } catch (e) {
      UniLogger.error("userRepo: $e");
      throw "Someting went wrong, Please try again";
    }
  }

  Future<void> updateUserDetails(UserModel updateUser) async {
    try {
      await _db
          .collection("Users")
          .doc(updateUser.id)
          .update(updateUser.toJson());
    } on FirebaseException catch (e) {
      throw UniFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw UniFormatException(code: "Invalid_format").message;
    } on PlatformException catch (e) {
      throw UniPlatformException(e.code).message;
    } catch (e) {
      UniLogger.error("userRepo: $e");
      throw "Someting went wrong, Please try again";
    }
  }

  Future<void> updateUserSingleField(Map<String, dynamic> json,
      {String? userId}) async {
    try {
      await _db
          .collection("Users")
          .doc(userId ?? _authRepository.authUser?.uid)
          .update(json);
    } on FirebaseException catch (e) {
      throw UniFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw UniFormatException(code: "Invalid_format").message;
    } on PlatformException catch (e) {
      throw UniPlatformException(e.code).message;
    } catch (e) {
      UniLogger.error("userRepo: $e");
      throw "Someting went wrong, Please try again";
    }
  }

  Future<void> removeUserRecord(String userId) async {
    try {
      await _db.collection("Users").doc(userId).delete();
    } on FirebaseException catch (e) {
      throw UniFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw UniFormatException(code: "Invalid_format").message;
    } on PlatformException catch (e) {
      throw UniPlatformException(e.code).message;
    } catch (e) {
      UniLogger.error("userRepo: $e");
      throw "Someting went wrong, Please try again";
    }
  }

  //Upload any Image
  Future<String> uploadImage(String path, XFile image) async {
    try {
      //creating image reference
      final ref = FirebaseStorage.instance.ref(path).child(image.name);

      //Stores image form device in the the ref
      await ref.putFile(File(image.path));

      //returns image as a network image
      final url = await ref.getDownloadURL();

      return url;
    } on FirebaseException catch (e) {
      throw UniFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw UniFormatException(code: "Invalid_format").message;
    } on PlatformException catch (e) {
      throw UniPlatformException(e.code).message;
    } catch (e) {
      UniLogger.error("userRepo: $e");
      throw "Someting went wrong, Please try again";
    }
  }

  Future<String?> getFcmToken(String receiverID) async {
    try {
      final docSnapshot = await _db.collection("Users").doc(receiverID).get();

      if (docSnapshot.exists) {
        return docSnapshot.data()?["FcmToken"];
      } else {
        return null;
      }
    } on FirebaseException catch (e) {
      throw UniFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw UniFormatException(code: "Invalid_format").message;
    } on PlatformException catch (e) {
      throw UniPlatformException(e.code).message;
    } catch (e) {
      UniLogger.error("userRepo: $e");
      throw "Someting went wrong, Please try again";
    }
  }

}
