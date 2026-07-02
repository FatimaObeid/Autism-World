import 'package:autism_world/adminDashboard.dart';
import 'package:autism_world/screens/childPage.dart';
import 'package:autism_world/screens/login.dart';
import 'package:autism_world/screens/register.dart';
import 'package:autism_world/specialist/specialist.dart';
import 'package:autism_world/screens/volunteer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'package:autism_world/l10n/app_localizations.dart';
import 'package:autism_world/screens/settings_provider.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => SettingsProvider())],
      child: const AppBuilder(),
    );
  }
}

// Create a separate widget to listen to provider changes
class AppBuilder extends StatelessWidget {
  const AppBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en', 'US'), Locale('ar', 'SA')],
      locale: settings.locale, // This will now trigger a rebuild when changed
      home: const Register(), // Set the initial page to RegisterPage
    );
  }
}

