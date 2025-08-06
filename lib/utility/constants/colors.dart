import 'package:flutter/material.dart';

class UniColors {
  UniColors._();

  //App Basic Colors
  static const Color primary = Color.fromARGB(255, 13, 169, 60);
  static const Color secondary = Colors.amber;
  static const Color accent = Color(0xFFb0c7ff);

  //Gradient Color
  static const Gradient linerGradient = LinearGradient(
      begin: Alignment(0.0, 0.0),
      end: Alignment(0.707, -0.707),
      colors: [
        Color(0xffff9a9e),
        Color(0xfffad0c4),
        Color(0xfffad0c5),
      ]);

  //Text Colors
  static const Color textPrimary = Color(0xff333333);
  static const Color textSecondary = Color(0xff6c757d);
  static const Color textWhite = Colors.white;

  //BackGround Colors
  static const Color light = Color.fromARGB(255, 230, 230, 230);
  static const Color dark = Color(0xff272727);
  static const Color primaryBackground = Color(0xfff3f5ff);

  //Background Containers Colors
  static const Color lightContainer = Color(0xfff6f6f6);
  // static Color darkContainer = UniColors.white.withOpacity(0.1);

  //Button Colors
  static const Color buttonPrimary = Color(0xff4b68ff);
  static const Color buttonSecondary = Color(0xff6c757d);
  static const Color buttonDisable = Color(0xffc4c4c4);

  //Border Colors
  static const Color borderPrimary = Color(0xffd9d9d9);
  static const Color borderSecondary = Color.fromARGB(255, 65, 65, 65);

  //Error and Validation Colors
  static const Color error = Color(0xffd32f2f);
  static const Color success = Color(0xff388e3c);
  static const Color warning = Color(0xfff57c00);
  static const Color info = Color(0xff1976d2);

  //Neutral Shades
  static const Color black = Color(0xff232323);
  static const Color darkerGrey = Color(0xff4f4f4f);
  static const Color darkGrey = Color(0xff939393);
  static const Color grey = Color(0xffe0e0e0);
  static const Color softGrey = Color(0xfff4f4f4);
  static const Color lightGrey = Color.fromARGB(255, 228, 223, 223);
  static const Color white = Color(0xffffffff);
}
