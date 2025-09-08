class BankModel {
  final String id;
  final String accountName;
  final String accountNumber;
  final String bankCode;
  final double? amount;

  BankModel({
    this.id = "",
    required this.accountName,
    required this.accountNumber,
    required this.amount,
    required this.bankCode,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "type": "bank",
      "accountName": accountName,
      "bankCode": bankCode,
      "accountNumber": accountNumber,
      "amount": amount,
    };
  }

  factory BankModel.fromJson(Map<String, dynamic> json, String id) {
    return BankModel(
      id: id,
      accountName: json["accountName"] ?? "",
      accountNumber: json["accountNumber"] ?? "",
      bankCode: json["bankCode"] ?? "",
      amount: json["amount"] ?? "",
    );
  }
}
