import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
 
import 'l10n/app_localizations.dart';
import 'providers/app_locale.dart';
import 'providers/scan_provider.dart';
import 'repositories/scan_repository.dart';
import 'screens/splash_screen.dart';
import 'services/disease_classifier.dart';
import 'theme/app_theme.dart';
 
/// Add sample records on first run so the demo looks populated.
/// Set to false once real scans should be the only content.
const bool kSeedDemoData = true;
 
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(AppTheme.systemUiOverlay);
  final prefs = await SharedPreferences.getInstance();
  final savedLanguage = prefs.getString(AppLocaleController.prefsKey);
  runApp(VineGuardApp(
    prefs: prefs,
    initialLocale: Locale(savedLanguage ?? 'en'),
  ));
}
 
class VineGuardApp extends StatelessWidget {
  final SharedPreferences? prefs;
  final Locale initialLocale;
 
  const VineGuardApp({
    super.key,
    this.prefs,
    this.initialLocale = const Locale('en'),
  });
 
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AppLocaleController(
            initialLocale: initialLocale,
            prefs: prefs,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => ScanProvider(
            repository: createScanRepository(),
            // Swap for TfliteDiseaseClassifier() once the trained model exists.
            classifier: MockDiseaseClassifier(),
            seedDemoData: kSeedDemoData,
            prefs: prefs,
          )..load(),
        ),
      ],
      child: Builder(
        builder: (context) {
          final localeController = context.watch<AppLocaleController>();
 
          return MaterialApp(
            title: 'VineGuard',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.theme,
            locale: localeController.locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localeResolutionCallback: (locale, supportedLocales) {
              if (locale == null) {
                return supportedLocales.first;
              }
 
              for (final supportedLocale in supportedLocales) {
                if (supportedLocale.languageCode == locale.languageCode) {
                  return supportedLocale;
                }
              }
 
              return supportedLocales.first;
            },
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}