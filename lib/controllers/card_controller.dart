import 'package:fanmint/models/card_model.dart';
import 'package:fanmint/utility/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CardsController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _loadInitialCards();
  }

  static CardsController get instance => Get.find<CardsController>();
  final subArr = <Map<String, dynamic>>[
    {"name": "Spotify", "icon": "assets/img/spotify_logo.png", "price": "5.99"},
    {
      "name": "YouTube Premium",
      "icon": "assets/img/youtube_logo.png",
      "price": "18.99"
    },
    {
      "name": "Microsoft OneDrive",
      "icon": "assets/img/onedrive_logo.png",
      "price": "29.99"
    },
    {
      "name": "NetFlix",
      "icon": "assets/img/netflix_logo.png",
      "price": "15.00"
    },
  ].obs;

  var cardList = <CardModel>[].obs;

  TextEditingController cardNameController = TextEditingController();
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController cardMonthYearController = TextEditingController();

  void _loadInitialCards() {
    cardList.addAll([
      CardModel(
          name: "Visa", number: "1234 5678 9012 3456", monthYear: "12/25"),
      CardModel(
          name: "MasterCard",
          number: "9876 5432 1098 7654",
          monthYear: "11/24"),
    ]);
  }

  void addCard() {
    final name = cardNameController.text.trim();
    final number = cardNumberController.text.trim();
    final monthYear = cardMonthYearController.text.trim();

    // ✅ Basic validation checks
    if (name.isEmpty || number.isEmpty || monthYear.isEmpty) {
      UniLoaders.warningSnackBar(
          title: "Missing Field", message: "Please fill in all card details.");
      return;
    }

    // ✅ Check for duplicates
    final exists = cardList.any((card) => card.number == number);
    if (exists) {
      UniLoaders.warningSnackBar(
          title: "Duplicate Card", message: "This card already exists.");
      return;
    }

    // ✅ Add card
    final newCard = CardModel(name: name, number: number, monthYear: monthYear);
    cardList.add(newCard);

    // ✅ Clear input fields after adding
    cardNameController.clear();
    cardNumberController.clear();
    cardMonthYearController.clear();

    Get.back();
    UniLoaders.successSnackBar(
        title: "Success", message: "Card added successfully.");
  }

  void deleteCard(CardModel card) {
    cardList.remove(card);
    UniLoaders.successSnackBar(
        title: "Deleted", message: "Card deleted successfully.");
  }

  @override
  void onClose() {
    cardNameController.dispose();
    cardNumberController.dispose();
    cardMonthYearController.dispose();
    super.onClose();
  }
}
