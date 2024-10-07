import 'package:aplikasi_manajemen_sdm/config/routes.dart';
import 'package:aplikasi_manajemen_sdm/config/theme/theme.dart';
import 'package:aplikasi_manajemen_sdm/view/auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting(
      'id_ID', null); // Initialize the locale for 'id_ID'

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Manajemen SDM',
      theme: mainTheme(),
      debugShowCheckedModeBanner: false,
      initialRoute: '/auth',
      locale: const Locale('id', 'ID'), // Set the default locale to Indonesian
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', 'US'), // English
        const Locale('id', 'ID'), // Indonesian
      ],
      onGenerateRoute: AppRoutes.onGenerateRoutes,
      home: AuthPage(),
    );
  }
}
