class MoMoWalletModel {
  final String id;
  final String phoneNumber;
  final String network;
  final double? amount;

  MoMoWalletModel(
      {this.id = "",
      required this.phoneNumber,
      required this.network,
       this.amount});

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "type": "momo",
      "phoneNumber": phoneNumber,
      "network": network,
      "amount": amount
    };
  }

  factory MoMoWalletModel.fromJson(Map<String, dynamic> json, String id) {
    return MoMoWalletModel(
      id: id,
      phoneNumber: json["phoneNumber"] ?? "",
      network: json["network"] ?? "",
      amount: json["amount"] ?? "",
    );
  }
}
