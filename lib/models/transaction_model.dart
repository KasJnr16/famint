class TransactionModel {
  final String id;
  final DateTime date;
  final double amount;
  final bool isDeposit;

  TransactionModel({
    required this.id,
    required this.date,
    required this.amount,
    required this.isDeposit,
  });

  /// Convert transaction → Map
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "date": date.millisecondsSinceEpoch,
      "amount": amount,
      "isDeposit": isDeposit,
    };
  }

  /// Factory for transaction from JSON/Firestore
  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json["id"],
      date: DateTime.fromMillisecondsSinceEpoch(json["date"]),
      amount: (json["amount"] as num).toDouble(),
      isDeposit: json["isDeposit"] ?? true,
    );
  }
}
