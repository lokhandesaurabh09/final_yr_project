import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
 
/// Holds the app language and remembers it between launches.
class AppLocaleController extends ChangeNotifier {
  AppLocaleController({
    Locale initialLocale = const Locale('en'),
    this.prefs,
  }) : _locale = initialLocale;
 
  static const String prefsKey = 'language';
 
  final SharedPreferences? prefs;
  Locale _locale;
 
  Locale get locale => _locale;
 
  void setLocale(Locale newLocale) {
    if (_locale.languageCode == newLocale.languageCode) return;
    _locale = newLocale;
    prefs?.setString(prefsKey, newLocale.languageCode);
    notifyListeners();
  }
}