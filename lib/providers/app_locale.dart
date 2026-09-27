import 'package:flutter/material.dart';

class AppLocaleController extends ChangeNotifier {
  AppLocaleController({Locale initialLocale = const Locale('en')})
      : _locale = initialLocale;

  Locale _locale;

  Locale get locale => _locale;

  void setLocale(Locale newLocale) {
    if (_locale.languageCode == newLocale.languageCode) return;
    _locale = newLocale;
    notifyListeners();
  }
}
