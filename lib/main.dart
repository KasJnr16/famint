import 'package:fanmint/app.dart';
import 'package:fanmint/firebase_options.dart';
import 'package:fanmint/repositories/authentication/authentication_repository.dart';
import 'package:fanmint/utility/theme/theme_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';

void main() async {
  FlutterNativeSplash.preserve(
      widgetsBinding: WidgetsFlutterBinding.ensureInitialized());

  //firebase
  if (defaultTargetPlatform == TargetPlatform.iOS) {
    await Firebase.initializeApp(
      name: 'fanmint_ios',
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } else {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  await GetStorage.init();
  Get.put(AuthenticationRepository());

  runApp(
    ChangeNotifierProvider(
      create: (context) => UniThemeProvider(),
      child: const App(),
    ),
  );
}
