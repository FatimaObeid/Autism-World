import 'package:flutter/material.dart';
import 'package:autism_world/l10n/app_localizations.dart'; // Make sure this matches your project name!

extension LocalizationExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
