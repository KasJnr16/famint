import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:fanmint/models/expense_model.dart';
import 'package:fanmint/repositories/authentication/authentication_repository.dart';
import 'package:fanmint/utility/exceptions/custom_exceptions.dart';
import 'package:fanmint/utility/logging/logger.dart';

class ExpenseRepository extends GetxController {
  static ExpenseRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final _authRepository = AuthenticationRepository.instance;

  /// Save Expense
  Future<void> saveExpense(ExpenseModel expense) async {
    try {
      await _db
          .collection("Users")
          .doc(_authRepository.authUser?.uid)
          .collection("Expenses")
          .doc(expense.id)
          .set(expense.toJson());
    } catch (e) {
      UniLogger.error("ExpenseRepo.saveExpense: $e");
      throw "Something went wrong, Please try again";
    }
  }

  /// Fetch all Expenses for current user
  Future<List<ExpenseModel>> fetchExpenses() async {
    try {
      final snapshot = await _db
          .collection("Users")
          .doc(_authRepository.authUser?.uid)
          .collection("Expenses")
          .orderBy("date", descending: true)
          .get();

      return snapshot.docs
          .map((doc) => ExpenseModel.fromSnapshot(doc))
          .toList();
    } on FirebaseException catch (e) {
      throw UniFirebaseException(e.code).message;
    } on FormatException {
      throw UniFormatException(code: "Invalid_format").message;
    } on PlatformException catch (e) {
      throw UniPlatformException(e.code).message;
    } catch (e) {
      UniLogger.error("ExpenseRepo.fetchExpenses: $e");
      throw "Something went wrong, Please try again";
    }
  }

  /// Fetch single Expense by ID
  Future<ExpenseModel?> fetchExpenseById(String expenseId) async {
    try {
      final doc = await _db
          .collection("Users")
          .doc(_authRepository.authUser?.uid)
          .collection("Expenses")
          .doc(expenseId)
          .get();

      if (doc.exists) {
        return ExpenseModel.fromSnapshot(doc);
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
      UniLogger.error("ExpenseRepo.fetchExpenseById: $e");
      throw "Something went wrong, Please try again";
    }
  }

  /// Update Expense
  Future<void> updateExpense(ExpenseModel expense) async {
    try {
      await _db
          .collection("Users")
          .doc(_authRepository.authUser?.uid)
          .collection("Expenses")
          .doc(expense.id)
          .update(expense.toJson());
    } on FirebaseException catch (e) {
      throw UniFirebaseException(e.code).message;
    } on FormatException {
      throw UniFormatException(code: "Invalid_format").message;
    } on PlatformException catch (e) {
      throw UniPlatformException(e.code).message;
    } catch (e) {
      UniLogger.error("ExpenseRepo.updateExpense: $e");
      throw "Something went wrong, Please try again";
    }
  }

  /// Remove Expense
  Future<void> removeExpense(String expenseId) async {
    try {
      await _db
          .collection("Users")
          .doc(_authRepository.authUser?.uid)
          .collection("Expenses")
          .doc(expenseId)
          .delete();
    } on FirebaseException catch (e) {
      throw UniFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw UniPlatformException(e.code).message;
    } catch (e) {
      UniLogger.error("ExpenseRepo.removeExpense: $e");
      throw "Something went wrong, Please try again";
    }
  }
}
