import 'package:fanmint/controllers/user/user_controller.dart';
import 'package:fanmint/repositories/user/user_repository.dart';
import 'package:fanmint/utility/device/network_manager.dart';
import 'package:get/get.dart';

class GeneralBindings extends Bindings {
  @override
  void dependencies() {
    //Repos
    Get.lazyPut(fenix: true, () => UserRepository());

    //Needed
    Get.put(NetworkManager());
    Get.put(UserController());
  }
}
