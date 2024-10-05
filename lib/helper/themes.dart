import 'package:flutter/material.dart';

class Themes {
  static ThemeData lightTheme() {
    return ThemeData.light(
      useMaterial3: true,
    ).copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: ThemeColors.m3baseline,
        brightness: Brightness.light,
        error: ThemeColors.errorColor,
      ),
      appBarTheme: const AppBarTheme(centerTitle: true),
    );
  }

  static ThemeData darkTheme() {
    return ThemeData.dark(
      useMaterial3: true,
    ).copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: ThemeColors.m3baseline,
        brightness: Brightness.dark,
        error: ThemeColors.errorColor,
      ),
      appBarTheme: const AppBarTheme(centerTitle: true),
    );
  }
}

class ThemeColors {
  static const Color m3baseline = Color(0xff6750a4);
  static const locationPin = Colors.lightBlue;
  static const errorColor = Colors.red;
}
