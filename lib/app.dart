import 'package:fanmint/bindings/general_bindings.dart';
import 'package:fanmint/common/color_extension.dart';
import 'package:fanmint/common_widget/circular_loader.dart';
import 'package:fanmint/utility/theme/theme.dart';
import 'package:fanmint/utility/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        themeMode: ThemeMode.system,
        theme: Provider.of<UniThemeProvider>(context).themeData,
        darkTheme: UniAppTheme.darkTheme,
        title: 'Fanmint',
        initialBinding: GeneralBindings(),
        debugShowCheckedModeBanner: false,
        home: Container(
          width: double.infinity,
          height: double.infinity,
          color: TColor.primary,
          child: Center(child: UniCircularLoader()),
        ));
  }
}
