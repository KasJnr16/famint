// ignore_for_file: body_might_complete_normally_nullable

import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fanmint/models/payment_model.dart';
import 'package:fanmint/repositories/payment_repository.dart';
import 'package:fanmint/utility/constants/enums.dart';
import 'package:fanmint/utility/logging/logger.dart';
import 'package:fanmint/utility/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:paystack_payment/paystack_payment.dart';

class PaymentController extends GetxController {
  static PaymentController get instance => Get.find();

  var secretKey = "";
  var publicKey = "";
  final _paymentRepo = Get.put(PaymentRepository());

  RxList<PaymentModel> paymentReceipts = <PaymentModel>[].obs;
  var isLoading = false.obs;

  Future<bool> makePayment({
    required String customerEmail,
    required String customerFullname,
    required double amount,
    required BuildContext context,
  }) async {
    var completer = Completer<bool>();
    bool isCompleted = false;

    final paystack = PaystackPayment(secretKey: secretKey);

    try {
      paystack.pay(
        email: customerEmail,
        context: context,
        amount: amount,
        currency: "GHS",
        onSuccess: (response) {
          isCompleted = true;
          Navigator.pop(context);
          final paymentInfo = PaymentModel(
            referenceId: response.reference,
            name: customerFullname.trim(),
            email: customerEmail,
            amount: amount,
            paidAt: Timestamp.now(),
            status: PaymentStatus.success.name,
          );
          _paymentRepo.savePaymentData(paymentInfo);
          UniLoaders.successSnackBar(message: response.message);
          UniLogger.info(response.message);
          completer.complete(true);
        },
        onError: (response) {
          if (isCompleted) return;
          isCompleted = true;
          Navigator.pop(context);
          final paymentInfo = PaymentModel(
            referenceId: response.reference ?? "",
            name: customerFullname.trim(),
            email: customerEmail,
            amount: amount,
            paidAt: Timestamp.now(),
            status: PaymentStatus.failed.name,
          );
          _paymentRepo.savePaymentData(paymentInfo);
          UniLoaders.warningSnackBar(message: response.message);
          UniLoaders.errorSnackBar(
            title: "Payment Error",
            message: response.message,
          );
          UniLogger.error(response.message);
          completer.complete(false);
        },
        onCancel: (response) {
          if (isCompleted) return;
          isCompleted = true;
          Navigator.pop(context);
          final paymentInfo = PaymentModel(
            referenceId: response.reference ?? "",
            name: customerFullname.trim(),
            email: customerEmail,
            amount: amount,
            paidAt: Timestamp.now(),
            status: PaymentStatus.cancelled.name,
          );
          _paymentRepo.savePaymentData(paymentInfo);
          UniLoaders.warningSnackBar(message: response.message);
          UniLogger.warning(response.message);
          completer.complete(false);
        },
      );
    } catch (e) {
      UniLoaders.errorSnackBar(title: "Payment Failed");
      UniLogger.error("Payment Error", e);
      completer.complete(false);
    }
    return completer.future;
  }

  fetchUserPaymentHistory() async {
    try {
      isLoading.value = true;
      paymentReceipts.value = await _paymentRepo.fetchUserPaymentData();
    } finally {
      isLoading.value = false;
    }
  }

  // ===== Withdrawal =====
  Future<bool> withdraw({
    required String bankCode,
    required String accountNumber,
    required String accountName,
    required double amount, // in GHS
  }) async {
    try {
      // 1. Create transfer recipient
      final recipientRes = await http.post(
        Uri.parse("https://api.paystack.co/transferrecipient"),
        headers: {
          "Authorization": "Bearer $secretKey",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "type": "nuban",
          "name": accountName,
          "account_number": accountNumber,
          "bank_code": bankCode, // e.g., 058 for GTBank
          "currency": "GHS",
        }),
      );

      final recipientData = jsonDecode(recipientRes.body);
      if (!(recipientData["status"] ?? false)) {
        UniLoaders.errorSnackBar(
            title: "Withdrawal Error", message: recipientData["message"]);
        return false;
      }

      final recipientCode = recipientData["data"]["recipient_code"];

      // 2. Initiate transfer
      final transferRes = await http.post(
        Uri.parse("https://api.paystack.co/transfer"),
        headers: {
          "Authorization": "Bearer $secretKey",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "source": "balance",
          "reason": "User Withdrawal",
          "amount": (amount * 100).toInt(),
          "recipient": recipientCode,
          "currency": "GHS",
        }),
      );

      final transferData = jsonDecode(transferRes.body);
      if (!(transferData["status"] ?? false)) {
        UniLoaders.errorSnackBar(
            title: "Withdrawal Failed", message: transferData["message"]);
        return false;
      }

      final transferInfo = transferData["data"];

      // 3. Save record in Firestore
      final paymentInfo = PaymentModel(
        referenceId: transferInfo["reference"],
        name: accountName,
        email: "", // optional, depends on user record
        amount: amount,
        paidAt: Timestamp.now(),
        status: transferInfo["status"], // pending, success, failed
      );
      await _paymentRepo.savePaymentData(paymentInfo);

      UniLoaders.successSnackBar(message: "Withdrawal initiated successfully");
      return true;
    } catch (e) {
      UniLogger.error("Withdrawal Error", e);
      UniLoaders.errorSnackBar(
          title: "Withdrawal Failed", message: "Something went wrong");
      return false;
    }
  }

  Future<bool> withdrawToMoMo({
    required String momoNumber,
    required String network, // e.g., "MTN", "VODAFONE", "AIRTELTIGO"
    required String accountName,
    required double amount, // in GHS
  }) async {
    try {
      // 1. Create MoMo transfer recipient
      final recipientRes = await http.post(
        Uri.parse("https://api.paystack.co/transferrecipient"),
        headers: {
          "Authorization": "Bearer $secretKey",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "type": "mobile_money",
          "name": accountName,
          "account_number": momoNumber,
          "bank_code": network, // must be MoMo network code
          "currency": "GHS",
        }),
      );

      final recipientData = jsonDecode(recipientRes.body);
      if (!(recipientData["status"] ?? false)) {
        UniLoaders.errorSnackBar(
            title: "MoMo Withdrawal Error", message: recipientData["message"]);
        return false;
      }

      final recipientCode = recipientData["data"]["recipient_code"];

      // 2. Initiate transfer
      final transferRes = await http.post(
        Uri.parse("https://api.paystack.co/transfer"),
        headers: {
          "Authorization": "Bearer $secretKey",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "source": "balance",
          "reason": "MoMo Withdrawal",
          "amount": (amount * 100).toInt(), // pesewas
          "recipient": recipientCode,
          "currency": "GHS",
        }),
      );

      final transferData = jsonDecode(transferRes.body);
      if (!(transferData["status"] ?? false)) {
        UniLoaders.errorSnackBar(
            title: "MoMo Withdrawal Failed", message: transferData["message"]);
        return false;
      }

      final transferInfo = transferData["data"];

      // 3. Save in Firestore
      final paymentInfo = PaymentModel(
        referenceId: transferInfo["reference"],
        name: accountName,
        email: "", // optional
        amount: amount,
        paidAt: Timestamp.now(),
        status: transferInfo["status"], // pending/success/failed
      );
      await _paymentRepo.savePaymentData(paymentInfo);

      UniLoaders.successSnackBar(message: "MoMo withdrawal initiated");
      return true;
    } catch (e) {
      UniLogger.error("MoMo Withdrawal Error", e);
      UniLoaders.errorSnackBar(
          title: "MoMo Withdrawal Failed", message: "Something went wrong");
      return false;
    }
  }
}
