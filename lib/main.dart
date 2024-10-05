import 'package:aplikasi_manajemen_sdm/config/routes.dart';
import 'package:aplikasi_manajemen_sdm/config/theme/color.dart';
import 'package:aplikasi_manajemen_sdm/config/theme/theme.dart';
import 'package:aplikasi_manajemen_sdm/view/auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(
    //   SystemUiOverlayStyle(
    //     statusBarColor: ColorNeutral.background.withOpacity(0.5), // Semi-transparent blue
    //     statusBarIconBrightness: Brightness.light, // Change the icons to light
    //     statusBarBrightness: Brightness.light, // Change the status bar brightness
    //   ),
    // );

    return MaterialApp(
      title: 'Aplikasi Manajemen SDM',
      theme: mainTheme(),
      initialRoute: '/auth',
      onGenerateRoute: AppRoutes.onGenerateRoutes,
      home: AuthPage(),
    );
  }
}
