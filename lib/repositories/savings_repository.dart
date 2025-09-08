import 'package:fanmint/models/savings_account_model.dart';
import 'package:fanmint/repositories/authentication/authentication_repository.dart';
import 'package:fanmint/utility/exceptions/custom_exceptions.dart';
import 'package:fanmint/utility/logging/logger.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class SavingsRepository extends GetxController {
  static SavingsRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final _authRepository = AuthenticationRepository.instance;

  /// Save a savings record
  Future<void> savePersonalSavingsRecord(SavingsAccountModel savings) async {
    try {
      _db
          .collection("Users")
          .doc(_authRepository.authUser?.uid)
          .collection("Savings")
          .doc(savings.id)
          .set(savings.toJson());
    } on FirebaseException catch (e) {
      throw UniFirebaseException(e.code).message;
    } on FormatException {
      throw UniFormatException(code: "Invalid_format").message;
    } on PlatformException catch (e) {
      throw UniPlatformException(e.code).message;
    } catch (e) {
      UniLogger.error("SavingsRepo.savePersonalSavingsRecord: $e");
      throw "Something went wrong, Please try again";
    }
  }

  /// Fetch all savings for current user
  Future<List<SavingsAccountModel>> fetchPersonalSavings() async {
    try {
      final snapshot = await _db
          .collection("Users")
          .doc(_authRepository.authUser?.uid)
          .collection("Savings")
          .get();

      return snapshot.docs
          .map((doc) => SavingsAccountModel.fromSnapshot(doc))
          .toList();
    } on FirebaseException catch (e) {
      throw UniFirebaseException(e.code).message;
    } on FormatException {
      throw UniFormatException(code: "Invalid_format").message;
    } on PlatformException catch (e) {
      throw UniPlatformException(e.code).message;
    } catch (e) {
      UniLogger.error("SavingsRepo.fetchPersonalSavings: $e");
      throw "Something went wrong, Please try again";
    }
  }

  /// Fetch single saving by ID
  Future<SavingsAccountModel?> fetchSavingsById(String savingId) async {
    try {
      final doc = await _db
          .collection("Users")
          .doc(_authRepository.authUser?.uid)
          .collection("Savings")
          .doc(savingId)
          .get();

      if (doc.exists) {
        return SavingsAccountModel.fromSnapshot(doc);
      } else {
        return null;
      }
    } on FirebaseException catch (e) {
      throw UniFirebaseException(e.code).message;
    } on FormatException {
      throw UniFormatException(code: "Invalid_format").message;
    } on PlatformException catch (e) {
      throw UniPlatformException(e.code).message;
    } catch (e) {
      UniLogger.error("SavingsRepo.fetchSavingsById: $e");
      throw "Something went wrong, Please try again";
    }
  }

  /// Update savings record
  Future<void> updateSavings(SavingsAccountModel savings) async {
    try {
      await _db
          .collection("Users")
          .doc(_authRepository.authUser?.uid)
          .collection("Savings")
          .doc(savings.id)
          .update(savings.toJson());
    } on FirebaseException catch (e) {
      throw UniFirebaseException(e.code).message;
    } on FormatException {
      throw UniFormatException(code: "Invalid_format").message;
    } on PlatformException catch (e) {
      throw UniPlatformException(e.code).message;
    } catch (e) {
      UniLogger.error("SavingsRepo.updateSavings: $e");
      throw "Something went wrong, Please try again";
    }
  }

  /// Remove savings record
  Future<void> removeSavings(String savingId) async {
    try {
      await _db
          .collection("Users")
          .doc(_authRepository.authUser?.uid)
          .collection("Savings")
          .doc(savingId)
          .delete();
    } on FirebaseException catch (e) {
      throw UniFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw UniPlatformException(e.code).message;
    } catch (e) {
      UniLogger.error("SavingsRepo.removeSavings: $e");
      throw "Something went wrong, Please try again";
    }
  }
}
