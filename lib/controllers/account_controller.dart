import 'package:fanmint/models/bank_model.dart';
import 'package:fanmint/models/momo_wallet_model.dart';
import 'package:fanmint/repositories/account_repository.dart';
import 'package:fanmint/utility/device/network_manager.dart';
import 'package:fanmint/utility/popups/fullscreen_loader.dart';
import 'package:fanmint/utility/popups/loaders.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class AccountController extends GetxController {
  static AccountController get instance => Get.find();

  final _accountRepo = Get.put(AccountRepository());

  //momo
  TextEditingController phoneNumber = TextEditingController();

  //bank
  TextEditingController accountName = TextEditingController();
  TextEditingController accountNumber = TextEditingController();
  TextEditingController bankCode = TextEditingController();
  TextEditingController amount = TextEditingController();

  GlobalKey<FormState> registerAccountKey = GlobalKey<FormState>();

  //wallets
  final RxList<MoMoWalletModel> momoWallets = <MoMoWalletModel>[].obs;
  final RxList<BankModel> banks = <BankModel>[].obs;

  // network dropdown
  var selectedNetwork = "".obs;
  final List<String> accountTypes = [
    "MTN",
    "VODAFONE",
    "AIRTELTIGO",
  ];

  final Uuid uuid = Uuid();

  @override
  void onInit() {
    super.onInit();
    fetchAccounts();
  }

  /// 🔹 Save MoMo Wallet
  Future<void> saveMomoWallet() async {
    try {
      UniFullScreenLoader.openLoadingDialog("Saving MoMo Wallet...");

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        UniFullScreenLoader.stopLoading();
        UniLoaders.errorSnackBar(
          title: "No Connection",
          message: "Please check your internet connection.",
        );
        return;
      }

      if (!registerAccountKey.currentState!.validate()) {
        UniFullScreenLoader.stopLoading();
        return;
      }

      final momo = MoMoWalletModel(
        id: uuid.v4(),
        phoneNumber: phoneNumber.text.trim(),
        network: selectedNetwork.value,
        amount: double.tryParse(amount.text.trim()),
      );

      await _accountRepo.saveMomoRecord(momo);
      momoWallets.add(momo);

      phoneNumber.clear();
      selectedNetwork.value = "";
      amount.clear();

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

  /// 🔹 Save Bank Card
  Future<void> saveBank() async {
    try {
      UniFullScreenLoader.openLoadingDialog("Saving Bank Info...");

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        UniFullScreenLoader.stopLoading();
        UniLoaders.errorSnackBar(
          title: "No Internet",
          message: "Please check your connection.",
        );
        return;
      }

      if (!registerAccountKey.currentState!.validate()) {
        UniFullScreenLoader.stopLoading();
        return;
      }

      final bank = BankModel(
          id: uuid.v4(),
          accountName: accountName.text.trim(),
          accountNumber: accountNumber.text.trim(),
          bankCode: bankCode.text
              .trim(), // Placeholder, replace with actual bank code if needed
          amount: double.tryParse(amount.text.trim()));

      await _accountRepo.saveBankRecord(bank);
      banks.add(bank);

      accountName.clear();
      accountNumber.clear();
      amount.clear();

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

  /// 🔹 Fetch all accounts
  Future<void> fetchAccounts() async {
    try {
      final accounts = await _accountRepo.fetchAccounts();

      // separate into lists
      momoWallets.assignAll(
        accounts.whereType<MoMoWalletModel>(),
      );
      banks.assignAll(
        accounts.whereType<BankModel>(),
      );
    } catch (e) {
      UniLoaders.errorSnackBar(title: "Error", message: e.toString());
    }
  }

  /// 🔹 Update an account
  Future<void> updateAccount(dynamic account) async {
    try {
      final amount = double.tryParse(this.amount.text.trim());

      UniFullScreenLoader.openLoadingDialog("Processing top up...");
      if (account == null) {
        UniFullScreenLoader.stopLoading();
        throw Exception("Account cannot be null");
      }
      if (amount == null || amount <= 0) {
        UniFullScreenLoader.stopLoading();
        throw Exception("Top-up amount must be greater than 0");
      }

      final double newAmount = (account.amount ?? 0) + amount;
      dynamic newAccount;

      if (account is MoMoWalletModel) {
        newAccount = MoMoWalletModel(
          id: account.id,
          phoneNumber: account.phoneNumber,
          network: account.network,
          amount: newAmount,
        );

        final index = momoWallets.indexWhere((momo) => momo.id == account.id);
        if (index != -1) {
          momoWallets[index] = newAccount;
        }
      } else if (account is BankModel) {
        newAccount = BankModel(
          id: account.id,
          accountName: account.accountName,
          accountNumber: account.accountNumber,
          bankCode: account.bankCode,
          amount: newAmount,
        );

        final index = banks.indexWhere((bank) => bank.id == account.id);
        if (index != -1) {
          banks[index] = newAccount;
        }
      } else {
        UniFullScreenLoader.stopLoading();
        throw Exception("Unsupported account type");
      }

      // Save updated account
      await AccountRepository.instance.updateAccount(newAccount);
      UniFullScreenLoader.stopLoading();
      Get.back();
      UniLoaders.successSnackBar(
        title: "Updated",
        message: "Balance added successfully.",
      );
    } catch (e) {
      UniFullScreenLoader.stopLoading();
      UniLoaders.errorSnackBar(
        title: "Error",
        message: e.toString(),
      );
    }
  }

  /// 🔹 Remove an account
  Future<void> removeAccount(String accountId, {bool isMomo = true}) async {
    try {
      await _accountRepo.removeAccount(accountId);
      if (isMomo) {
        momoWallets.removeWhere((wallet) => wallet.id == accountId);
      } else {
        banks.removeWhere((bank) => bank.id == accountId);
      }
      UniLoaders.successSnackBar(
        title: "Removed",
        message: "Account deleted successfully.",
      );
    } catch (e) {
      UniLoaders.errorSnackBar(title: "Error", message: e.toString());
    }
  }
}
