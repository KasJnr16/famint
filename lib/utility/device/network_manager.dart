import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fanmint/utility/popups/loaders.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class NetworkManager extends GetxController {
  static NetworkManager get instance => Get.find();

  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  final Rx<ConnectivityResult> _connectionStatus = ConnectivityResult.none.obs;

  // checking internet status continually
  @override
  void onInit() {
    super.onInit();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  // updates connection status based on the changes and provides feedback
  Future<void> _updateConnectionStatus(List<ConnectivityResult> results) async {
    if (results.isNotEmpty) {
      final result =
          results.first; // Take the first ConnectivityResult from the list
      _connectionStatus.value = result;

      if (_connectionStatus.value == ConnectivityResult.none) {
        UniLoaders.customToast(message: "No Internet Connection");
      }
    }
  }

  // checks internet connection, returns true if yes
  Future<bool> isConnected() async {
    try {
      final result = await _connectivity.checkConnectivity();
      if (result == ConnectivityResult.none) {
        return false;
      } else {
        return true;
      }
    } on PlatformException catch (_) {
      return false;
    }
  }

  @override
  void onClose() {
    _connectivitySubscription.cancel();
    super.onClose();
  }
}
