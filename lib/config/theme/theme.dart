import 'package:aplikasi_manajemen_sdm/config/theme/color.dart';
import 'package:flutter/material.dart';

ThemeData mainTheme() {
  return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
          primary: ColorPrimary.orange,
          secondary: ColorPrimary.green,
          tertiary: ColorPrimary.blue,
          error: ColorPrimary.orange,
          surface: ColorNeutral.background,
          surfaceContainer: ColorNeutral.white,
          onSurfaceVariant: ColorNeutral.gray),
      textTheme: const TextTheme(
          displayLarge: TextStyle(
              fontWeight: FontWeight.w700,
              fontFamily: 'Plus Jakarta',
              color: ColorNeutral.black),
          displayMedium: TextStyle(
              fontWeight: FontWeight.w600,
              fontFamily: 'Plus Jakarta',
              color: ColorNeutral.black),
          bodyMedium:
              TextStyle(fontFamily: 'Plus Jakarta', color: ColorNeutral.black),
          bodySmall: TextStyle(
              fontFamily: 'Plus Jakarta',
              fontWeight: FontWeight.w300,
              color: ColorNeutral.black)));
}
