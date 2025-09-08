import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fanmint/models/budget_model.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:fanmint/repositories/authentication/authentication_repository.dart';
import 'package:fanmint/utility/exceptions/custom_exceptions.dart';
import 'package:fanmint/utility/logging/logger.dart';

class BudgetRepository extends GetxController {
  static BudgetRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final _authRepository = AuthenticationRepository.instance;

  /// Save a Budget
  Future<void> saveBudget(BudgetModel budget) async {
    try {
      await _db
          .collection("Users")
          .doc(_authRepository.authUser?.uid)
          .collection("Budget")
          .doc(budget.id)
          .set(budget.toJson());
    } catch (e) {
      UniLogger.error("BudgetRepo.saveBudget: $e");
      throw "Something went wrong, Please try again";
    }
  }

  /// Fetch all Budgets for current user
  Future<List<BudgetModel>> fetchBudgets() async {
    try {
      final snapshot = await _db
          .collection("Users")
          .doc(_authRepository.authUser?.uid)
          .collection("Budget")
          .orderBy("startDate", descending: true)
          .get();

      return snapshot.docs.map((doc) => BudgetModel.fromSnapshot(doc)).toList();
    } on FirebaseException catch (e) {
      throw UniFirebaseException(e.code).message;
    } on FormatException {
      throw UniFormatException(code: "Invalid_format").message;
    } on PlatformException catch (e) {
      throw UniPlatformException(e.code).message;
    } catch (e) {
      UniLogger.error("BudgetRepo.fetchBudgets: $e");
      throw "Something went wrong, Please try again";
    }
  }

  /// Fetch single Budget by ID
  Future<BudgetModel?> fetchBudgetById(String budgetId) async {
    try {
      final doc = await _db
          .collection("Users")
          .doc(_authRepository.authUser?.uid)
          .collection("Budget")
          .doc(budgetId)
          .get();

      if (doc.exists) {
        return BudgetModel.fromSnapshot(doc);
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
      UniLogger.error("BudgetRepo.fetchBudgetById: $e");
      throw "Something went wrong, Please try again";
    }
  }

  /// Update Budget
  Future<void> updateBudget(BudgetModel budget) async {
    try {
      await _db
          .collection("Users")
          .doc(_authRepository.authUser?.uid)
          .collection("Budget")
          .doc(budget.id)
          .update(budget.toJson());
    } on FirebaseException catch (e) {
      throw UniFirebaseException(e.code).message;
    } on FormatException {
      throw UniFormatException(code: "Invalid_format").message;
    } on PlatformException catch (e) {
      throw UniPlatformException(e.code).message;
    } catch (e) {
      UniLogger.error("BudgetRepo.updateBudget: $e");
      throw "Something went wrong, Please try again";
    }
  }

  /// Remove Budget
  Future<void> removeBudget(String budgetId) async {
    try {
      await _db
          .collection("Users")
          .doc(_authRepository.authUser?.uid)
          .collection("Budget")
          .doc(budgetId)
          .delete();
    } on FirebaseException catch (e) {
      throw UniFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw UniPlatformException(e.code).message;
    } catch (e) {
      UniLogger.error("BudgetRepo.removeBudget: $e");
      throw "Something went wrong, Please try again";
    }
  }
}
