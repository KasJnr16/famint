import 'package:flutter/material.dart';

class UniTextTheme {
  UniTextTheme._();

  static const String fontFamily = 'Inter';

  static final lightTextTheme = TextTheme(
    headlineLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 32.0,
        fontWeight: FontWeight.bold,
        color: Colors.black),
    headlineMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 24.0,
        fontWeight: FontWeight.w600,
        color: Colors.black),
    headlineSmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 18.0,
        fontWeight: FontWeight.w600,
        color: Colors.black),
    titleLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 16.0,
        fontWeight: FontWeight.w600,
        color: Colors.black),
    titleMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 16.0,
        fontWeight: FontWeight.w500,
        color: Colors.black),
    titleSmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 16.0,
        fontWeight: FontWeight.w400,
        color: Colors.black),
    bodyLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
        color: Colors.black),
    bodyMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 14.0,
        fontWeight: FontWeight.normal,
        color: Colors.black),
    bodySmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
        color: Colors.black.withOpacity(0.5)),
    labelLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 12.0,
        fontWeight: FontWeight.normal,
        color: Colors.black),
    labelMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 12.0,
        fontWeight: FontWeight.normal,
        color: Colors.black.withOpacity(0.5)),
  );

  static final darkTextTheme = TextTheme(
    headlineLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 32.0,
        fontWeight: FontWeight.bold,
        color: Colors.white),
    headlineMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 24.0,
        fontWeight: FontWeight.w600,
        color: Colors.white),
    headlineSmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 18.0,
        fontWeight: FontWeight.w600,
        color: Colors.white),
    titleLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 16.0,
        fontWeight: FontWeight.w600,
        color: Colors.white),
    titleMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 16.0,
        fontWeight: FontWeight.w500,
        color: Colors.white),
    titleSmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 16.0,
        fontWeight: FontWeight.w400,
        color: Colors.white),
    bodyLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
        color: Colors.white),
    bodyMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 14.0,
        fontWeight: FontWeight.normal,
        color: Colors.white),
    bodySmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
        color: Colors.white.withOpacity(0.5)),
    labelLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 12.0,
        fontWeight: FontWeight.normal,
        color: Colors.white),
    labelMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 12.0,
        fontWeight: FontWeight.normal,
        color: Colors.white.withOpacity(0.5)),
  );
}
