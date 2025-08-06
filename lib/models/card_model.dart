class CardModel {
  final String cardName;
  final String cardCvc;
  final String cardNumber;
  final String expiryDate;

  CardModel({
    required this.cardName,
    required this.cardNumber,
    required this.cardCvc,
    required this.expiryDate,
  });
}
