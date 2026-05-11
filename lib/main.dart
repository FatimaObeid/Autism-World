import 'package:autism_world/screens/childPage.dart';
import 'package:autism_world/screens/login.dart';
import 'package:autism_world/screens/register.dart';
import 'package:autism_world/specialist/specialist.dart';
import 'package:autism_world/screens/volunteer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:autism_world/l10n/app_localizations.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [Locale('en', 'US'), Locale('ar', 'SA')],
      locale: const Locale('ar', 'SA'), // Set Arabic as the default locale
      home: Register(),
    );
  }
}

