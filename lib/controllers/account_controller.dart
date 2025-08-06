import 'package:fanmint/models/card_model.dart';
import 'package:fanmint/models/momo_wallet_model.dart';
import 'package:fanmint/utility/device/network_manager.dart';
import 'package:fanmint/utility/popups/fullscreen_loader.dart';
import 'package:fanmint/utility/popups/loaders.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class AccountController extends GetxController {
  static AccountController get instance => Get.find();

  //momo
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController momoAmount = TextEditingController();

  //Cards
  TextEditingController cardName = TextEditingController();
  TextEditingController cardNumber = TextEditingController();
  TextEditingController cardCvc = TextEditingController();
  TextEditingController cardDate = TextEditingController();

  GlobalKey<FormState> registerAccountKey = GlobalKey<FormState>();

  //wallets
  final RxList<MoMoWalletModel> momoWallets = <MoMoWalletModel>[].obs;
  final RxList<CardModel> bankCards = <CardModel>[].obs;

  void saveMomoWallet() async {
    try {
      // Start loading
      UniFullScreenLoader.openLoadingDialog("Saving MoMo Wallet...");

      // Check connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        UniFullScreenLoader.stopLoading();
        UniLoaders.errorSnackBar(
          title: "No Connection",
          message: "Please check your internet connection.",
        );
        return;
      }

      // Validate form
      if (!registerAccountKey.currentState!.validate()) {
        UniFullScreenLoader.stopLoading();
        return;
      }

      // Parse amount safely
      final double amount = double.tryParse(momoAmount.text.trim()) ?? 0;

      // Add to observable list (or send to backend)
      momoWallets.add(
        MoMoWalletModel(
          phoneNumber: phoneNumber.text.trim(),
          amount: amount,
        ),
      );

      phoneNumber.clear();
      momoAmount.clear();

      // Stop loader and show success
      UniFullScreenLoader.stopLoading();
      Get.back();
      UniLoaders.successSnackBar(
        title: "Saved",
        message: "MoMo Wallet added successfully.",
      );
    } catch (e) {
      UniFullScreenLoader.stopLoading();
      UniLoaders.errorSnackBar(title: "Error", message: e.toString());
    }
  }

  void saveBankCard() async {
    try {
      // Start loading
      UniFullScreenLoader.openLoadingDialog("Saving Card Info...");

      // Check internet connection
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        UniFullScreenLoader.stopLoading();
        UniLoaders.errorSnackBar(
          title: "No Internet",
          message: "Please check your connection.",
        );
        return;
      }

      // Validate the form
      if (!registerAccountKey.currentState!.validate()) {
        UniFullScreenLoader.stopLoading();
        return;
      }

      // Save the card
      bankCards.add(CardModel(
        cardName: cardName.text.trim(),
        cardNumber: cardNumber.text.trim(),
        cardCvc: cardCvc.text.trim(),
        expiryDate: cardDate.text.trim(),
      ));

      // Clear fields
      cardNumber.clear();
      cardCvc.clear();
      cardDate.clear();

      // Show success
      UniFullScreenLoader.stopLoading();
      Get.back();
      UniLoaders.successSnackBar(
        title: "Saved",
        message: "Card details saved successfully.",
      );
    } catch (e) {
      UniFullScreenLoader.stopLoading();
      UniLoaders.errorSnackBar(title: "Error", message: e.toString());
    }
  }
}
