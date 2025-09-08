import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fanmint/models/payment_model.dart';
import 'package:fanmint/repositories/authentication/authentication_repository.dart';
import 'package:fanmint/utility/popups/loaders.dart';
import 'package:get/get.dart';

class PaymentRepository extends GetxController {
  static PaymentRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final currentUser = AuthenticationRepository.instance.authUser;

  Future<void> savePaymentData(PaymentModel paymentData) async {
    try {
      await _db
          .collection("Users")
          .doc(currentUser!.uid)
          .collection("Payments")
          .add(paymentData.toJson());
    } on Exception {
      rethrow;
    }
  }

  Future<List<PaymentModel>> fetchUserPaymentData() async {
    try {
      final paymentDocs =
          await _db
              .collection("Users")
              .doc(currentUser!.uid)
              .collection("Payments")
              .orderBy("PaidAt", descending: true)
              .get();
      if (paymentDocs.docs.isEmpty) {
        return [];
      }
      return paymentDocs.docs
          .map((doc) => PaymentModel.fromQuerySnapshot(doc))
          .toList();
    } on Exception catch (e) {
      UniLoaders.errorSnackBar(
        title: "Error",
        message: "Error fetching payments: $e",
      );
      return [];
    }
  }
}
