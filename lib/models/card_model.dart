class CardModel {
  final String name;
  final String number;
  final String monthYear;

  CardModel({
    required this.name,
    required this.number,
    required this.monthYear,
  });

  Map<String, dynamic> toJson() => {
        "name": name,
        "number": number,
        "month_year": monthYear,
      };

  factory CardModel.fromJson(Map<String, dynamic> json) => CardModel(
        name: json["name"],
        number: json["number"],
        monthYear: json["month_year"],
      );
}
