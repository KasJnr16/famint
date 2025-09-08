import 'package:fanmint/models/bank_model.dart';
import 'package:fanmint/repositories/authentication/authentication_repository.dart';
import 'package:fanmint/utility/exceptions/custom_exceptions.dart';
import 'package:fanmint/utility/logging/logger.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import '../models/momo_wallet_model.dart';

class AccountRepository extends GetxController {
  static AccountRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final _authRepository = AuthenticationRepository.instance;

  /// Save MoMo Account
  Future<void> saveMomoRecord(MoMoWalletModel momo) async {
    try {
      _db
          .collection("Users")
          .doc(_authRepository.authUser?.uid)
          .collection("Accounts")
          .doc(momo.id)
          .set(momo.toJson());
    } catch (e) {
      UniLogger.error("AccountRepo.saveMomoRecord: $e");
      throw "Something went wrong, Please try again";
    }
  }

  Future<void> saveBankRecord(BankModel bank) async {
    try {
      _db
          .collection("Users")
          .doc(_authRepository.authUser?.uid)
          .collection("Accounts")
          .doc(bank.id)
          .set(bank.toJson());
    } catch (e) {
      UniLogger.error("AccountRepo.saveBankRecord: $e");
      throw "Something went wrong, Please try again";
    }
  }

  /// Fetch all accounts for current user
  Future<List<dynamic>> fetchAccounts() async {
    try {
      final snapshot = await _db
          .collection("Users")
          .doc(_authRepository.authUser?.uid)
          .collection("Accounts")
          .get();

      return snapshot.docs
          .map((doc) {
            final data = doc.data();
            final type = data["type"];

            if (type == "bank") {
              return BankModel.fromJson(data, doc.id);
            } else if (type == "momo") {
              return MoMoWalletModel.fromJson(data, doc.id);
            } else {
              return null; // or throw
            }
          })
          .whereType<dynamic>()
          .toList();
    } catch (e) {
      UniLogger.error("AccountRepo.fetchAccounts: $e");
      throw "Something went wrong, Please try again";
    }
  }

  /// Fetch single account by ID
  Future<dynamic> fetchAccountById(String accountId) async {
    try {
      final doc = await _db
          .collection("Users")
          .doc(_authRepository.authUser?.uid)
          .collection("Accounts")
          .doc(accountId)
          .get();

      if (doc.exists) {
        final data = doc.data()!;
        final type = data["type"];

        if (type == "bank") {
          return BankModel.fromJson(data, doc.id);
        } else if (type == "momo") {
          return MoMoWalletModel.fromJson(data, doc.id);
        } else {
          return null; // or throw an exception
        }
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
      UniLogger.error("AccountRepo.fetchAccountById: $e");
      throw "Something went wrong, Please try again";
    }
  }

  /// Update account (Bank or MoMo)
  Future<void> updateAccount(dynamic account) async {
    try {
      await _db
          .collection("Users")
          .doc(_authRepository.authUser?.uid)
          .collection("Accounts")
          .doc(account.id)
          .update(account.toJson());
    } on FirebaseException catch (e) {
      throw UniFirebaseException(e.code).message;
    } on FormatException {
      throw UniFormatException(code: "Invalid_format").message;
    } on PlatformException catch (e) {
      throw UniPlatformException(e.code).message;
    } catch (e) {
      UniLogger.error("AccountRepo.updateAccount: $e");
      throw "Something went wrong, Please try again";
    }
  }

  /// Remove account
  Future<void> removeAccount(String accountId) async {
    try {
      await _db
          .collection("Users")
          .doc(_authRepository.authUser?.uid)
          .collection("Accounts")
          .doc(accountId)
          .delete();
    } on FirebaseException catch (e) {
      throw UniFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw UniPlatformException(e.code).message;
    } catch (e) {
      UniLogger.error("AccountRepo.removeAccount: $e");
      throw "Something went wrong, Please try again";
    }
  }
}
