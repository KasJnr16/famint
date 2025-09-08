import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fanmint/models/transaction_model.dart';

class SavingsAccountModel {
  final String? id;
  String accountName;
  double? balance;
  String? reason;
  DateTime dateAdded;
  double? targetAmount;
  DateTime? targetDate;
  bool isCompleted;
  bool enableWithdrawal;
  List<TransactionModel> transactions;

  SavingsAccountModel({
    this.id,
    required this.accountName,
    this.balance,
    this.reason,
    required this.dateAdded,
    this.targetAmount,
    this.targetDate,
    this.isCompleted = false,
    this.enableWithdrawal = false,
    List<TransactionModel>? transactions,
  }) : transactions = transactions ?? [];

  /// Convert model → Map (for Firestore/JSON)
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "accountName": accountName,
      "amount": balance,
      "reason": reason,
      "dateAdded": dateAdded.millisecondsSinceEpoch,
      "targetAmount": targetAmount,
      "targetDate": targetDate?.millisecondsSinceEpoch,
      "isCompleted": isCompleted,
      "enableWithdrawal": enableWithdrawal,
      "transactions": transactions.map((t) => t.toJson()).toList(),
    };
  }

  /// Factory to build model from Firestore snapshot
  factory SavingsAccountModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return SavingsAccountModel(
      id: data["id"] ?? doc.id,
      accountName: data["accountName"] ?? "",
      balance: (data["amount"] ?? 0).toDouble(),
      reason: data["reason"],
      dateAdded: DateTime.fromMillisecondsSinceEpoch(data["dateAdded"]),
      targetAmount: data["targetAmount"] != null
          ? (data["targetAmount"] as num).toDouble()
          : null,
      targetDate: data["targetDate"] != null
          ? DateTime.fromMillisecondsSinceEpoch(data["targetDate"])
          : null,
      isCompleted: data["isCompleted"] ?? false,
      enableWithdrawal: data["enableWithdrawal"] ?? false,
      transactions: (data["transactions"] as List<dynamic>?)
              ?.map((t) => TransactionModel.fromJson(t))
              .toList() ??
          [],
    );
  }
}
