import 'package:fanmint/controllers/account_controller.dart';
import 'package:fanmint/controllers/budget_controller.dart';
import 'package:fanmint/controllers/expense_controller.dart';
import 'package:fanmint/controllers/payment_controller.dart';
import 'package:fanmint/controllers/savings_controller.dart';
import 'package:fanmint/controllers/user/user_controller.dart';
import 'package:fanmint/repositories/user/user_repository.dart';
import 'package:fanmint/utility/device/network_manager.dart';
import 'package:get/get.dart';

class GeneralBindings extends Bindings {
  @override
  void dependencies() {
    //Repos
    Get.put(UserRepository());

    //Needed
    Get.put(NetworkManager());
    Get.put(UserController());

    Get.lazyPut(fenix: true, () => BudgetController());
    Get.lazyPut(fenix: true, () => SavingsController());
    Get.lazyPut(fenix: true, () => AccountController());
    Get.lazyPut(fenix: true, () => ExpenseController());
    Get.lazyPut(fenix: true, () => PaymentController());
  }
}
