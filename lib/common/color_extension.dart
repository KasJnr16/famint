import 'package:flutter/material.dart';

class TColor {
  static Color get primary => Color.fromARGB(255, 13, 169, 60);
  static Color get primary500 => const Color.fromARGB(255, 51, 188, 74);
  static Color get primary20 => const Color.fromARGB(255, 24, 163, 89);
  static Color get primary10 => const Color.fromARGB(255, 36, 166, 218);
  static Color get primary5 => const Color.fromARGB(255, 19, 161, 76);
  static Color get primary0 => const Color(0xffE4D3FF);

  static Color get secondary => Colors.amber;
  static Color get secondary50 => const Color.fromARGB(255, 145, 159, 22);
  static Color get secondary0 => const Color(0xffFFD2CC);

  static Color get secondaryG => const Color(0xff00FAD9);
  static Color get secondaryG50 => const Color(0xff7DFFEE);

  static Color get gray => const Color(0xff0E0E12);
  static Color get gray80 => const Color(0xff1C1C23);
  static Color get gray70 => const Color(0xff353542);
  static Color get gray60 => const Color(0xff4E4E61);
  static Color get gray50 => const Color(0xff666680);
  static Color get gray40 => const Color(0xff83839C);
  static Color get gray30 => const Color(0xffA2A2B5);
  static Color get gray20 => const Color(0xffC1C1CD);
  static Color get gray10 => const Color(0xffE0E0E6);

  static Color get border => const Color(0xffCFCFFC);
  static Color get primaryText => Colors.white;
  static Color get secondaryText => gray60;

  static Color get white => Colors.white;
}
