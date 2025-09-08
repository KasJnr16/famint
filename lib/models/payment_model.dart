import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentModel {
  final String? referenceId;
  final String? name;
  final String? email;
  final double? amount;
  final Timestamp? paidAt;
  final String? status;

  PaymentModel({
    required this.referenceId,
    required this.name,
    required this.email,
    required this.amount,
    required this.paidAt,
    required this.status,
  });

  /// Empty instance
  static PaymentModel empty() => PaymentModel(
    referenceId: "",
    name: "",
    email: "",
    amount: 0.0,
    paidAt: Timestamp.now(),
    status: "",
  );

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      "ReferenceId": referenceId,
      "Name": name,
      "Email": email,
      "Amount": amount,
      "PaidAt": paidAt,
      "Status": status,
    };
  }

  /// From Firestore document
  factory PaymentModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    return PaymentModel(
      referenceId: data["ReferenceId"] ?? "",
      name: data["Name"] ?? "",
      email: data["Email"] ?? "",
      amount: data["Amount"] ?? 0.0,
      paidAt: data["PaidAt"] ?? Timestamp.now(),
      status: data["Status"] ?? "",
    );
  }

  /// From Firestore query
  factory PaymentModel.fromQuerySnapshot(QueryDocumentSnapshot<Object?> doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PaymentModel(
      referenceId: data["ReferenceId"] ?? "",
      name: data["Name"] ?? "",
      email: data["Email"] ?? "",
      amount: data["Amount"] ?? 0.0,
      paidAt: data["PaidAt"] ?? Timestamp.now(),
      status: data["Status"] ?? "",
    );
  }
}
