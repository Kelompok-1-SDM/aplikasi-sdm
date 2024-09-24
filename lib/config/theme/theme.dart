import 'package:flutter/material.dart';

ThemeData mainTheme() {
  return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(brightness: Brightness.light),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontWeight: FontWeight.w700,
          fontFamily: 'Plus Jakarta'
        ),
        displayMedium: TextStyle(
          fontWeight: FontWeight.w700,
          fontFamily: 'Plus Jakarta'
        ),
      ));
}
