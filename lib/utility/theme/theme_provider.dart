import 'package:fanmint/utility/theme/theme.dart';
import 'package:flutter/material.dart';

class UniThemeProvider extends ChangeNotifier {
  ThemeData _themeData = UniAppTheme.lightTheme;

  ThemeData get themeData => _themeData;

  bool get isDarkMode => _themeData == UniAppTheme.darkTheme;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() {
    if (_themeData == UniAppTheme.lightTheme) {
      themeData = UniAppTheme.darkTheme;
    } else {
      themeData = UniAppTheme.lightTheme;
    }
  }
}
