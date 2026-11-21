import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_mr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('mr'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'VineGuard'**
  String get appName;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @scanLeaf.
  ///
  /// In en, this message translates to:
  /// **'Scan Leaf'**
  String get scanLeaf;

  /// No description provided for @recentScans.
  ///
  /// In en, this message translates to:
  /// **'Recent Scans'**
  String get recentScans;

  /// No description provided for @diseaseDetected.
  ///
  /// In en, this message translates to:
  /// **'Disease Detected'**
  String get diseaseDetected;

  /// No description provided for @healthy.
  ///
  /// In en, this message translates to:
  /// **'Healthy'**
  String get healthy;

  /// No description provided for @scans.
  ///
  /// In en, this message translates to:
  /// **'Scans'**
  String get scans;

  /// No description provided for @diseases.
  ///
  /// In en, this message translates to:
  /// **'Diseases'**
  String get diseases;

  /// No description provided for @confidence.
  ///
  /// In en, this message translates to:
  /// **'Confidence'**
  String get confidence;

  /// No description provided for @severity.
  ///
  /// In en, this message translates to:
  /// **'Severity'**
  String get severity;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @symptoms.
  ///
  /// In en, this message translates to:
  /// **'Symptoms'**
  String get symptoms;

  /// No description provided for @treatment.
  ///
  /// In en, this message translates to:
  /// **'Treatment'**
  String get treatment;

  /// No description provided for @scanNow.
  ///
  /// In en, this message translates to:
  /// **'Scan a leaf now'**
  String get scanNow;

  /// No description provided for @tapCamera.
  ///
  /// In en, this message translates to:
  /// **'Tap the camera button below'**
  String get tapCamera;

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning 👋'**
  String get goodMorning;

  /// No description provided for @vineyardHealth.
  ///
  /// In en, this message translates to:
  /// **'Vineyard health overview'**
  String get vineyardHealth;

  /// No description provided for @vineyardWeather.
  ///
  /// In en, this message translates to:
  /// **'Vineyard Weather'**
  String get vineyardWeather;

  /// No description provided for @humidity.
  ///
  /// In en, this message translates to:
  /// **'Humidity'**
  String get humidity;

  /// No description provided for @wind.
  ///
  /// In en, this message translates to:
  /// **'Wind'**
  String get wind;

  /// No description provided for @feelsLike.
  ///
  /// In en, this message translates to:
  /// **'Feels like'**
  String get feelsLike;

  /// No description provided for @diseaseRiskIndex.
  ///
  /// In en, this message translates to:
  /// **'Disease Risk Index'**
  String get diseaseRiskIndex;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View all →'**
  String get viewAll;

  /// No description provided for @saveResult.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveResult;

  /// No description provided for @backToDashboard.
  ///
  /// In en, this message translates to:
  /// **'Back to Dashboard'**
  String get backToDashboard;

  /// No description provided for @analyzing.
  ///
  /// In en, this message translates to:
  /// **'Analyzing leaf...'**
  String get analyzing;

  /// No description provided for @centerLeaf.
  ///
  /// In en, this message translates to:
  /// **'Center a grape leaf in the frame'**
  String get centerLeaf;

  /// No description provided for @scanHistory.
  ///
  /// In en, this message translates to:
  /// **'Scan History'**
  String get scanHistory;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @diseased.
  ///
  /// In en, this message translates to:
  /// **'Diseased'**
  String get diseased;

  /// No description provided for @thisWeek.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get thisWeek;

  /// No description provided for @moderate.
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get moderate;

  /// No description provided for @severe.
  ///
  /// In en, this message translates to:
  /// **'Severe'**
  String get severe;

  /// No description provided for @mild.
  ///
  /// In en, this message translates to:
  /// **'Mild'**
  String get mild;

  /// No description provided for @noDisease.
  ///
  /// In en, this message translates to:
  /// **'No disease'**
  String get noDisease;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @flip.
  ///
  /// In en, this message translates to:
  /// **'Flip'**
  String get flip;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @guide.
  ///
  /// In en, this message translates to:
  /// **'Guide'**
  String get guide;

  /// No description provided for @guideSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Learn to recognise common grape leaf problems'**
  String get guideSubtitle;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @darkModeSoon.
  ///
  /// In en, this message translates to:
  /// **'Dark mode is coming soon'**
  String get darkModeSoon;

  /// No description provided for @appSettings.
  ///
  /// In en, this message translates to:
  /// **'App settings'**
  String get appSettings;

  /// No description provided for @modelAndData.
  ///
  /// In en, this message translates to:
  /// **'Model & data'**
  String get modelAndData;

  /// No description provided for @modelName.
  ///
  /// In en, this message translates to:
  /// **'Model'**
  String get modelName;

  /// No description provided for @demoModelNote.
  ///
  /// In en, this message translates to:
  /// **'Results come from a demo classifier. The trained model is not connected yet.'**
  String get demoModelNote;

  /// No description provided for @savedScans.
  ///
  /// In en, this message translates to:
  /// **'Saved scans'**
  String get savedScans;

  /// No description provided for @sampleRecords.
  ///
  /// In en, this message translates to:
  /// **'Sample records'**
  String get sampleRecords;

  /// No description provided for @removeSamples.
  ///
  /// In en, this message translates to:
  /// **'Remove sample records'**
  String get removeSamples;

  /// No description provided for @addSamples.
  ///
  /// In en, this message translates to:
  /// **'Add sample records'**
  String get addSamples;

  /// No description provided for @deleteAllScans.
  ///
  /// In en, this message translates to:
  /// **'Delete all scans'**
  String get deleteAllScans;

  /// No description provided for @removeSamplesWarning.
  ///
  /// In en, this message translates to:
  /// **'The sample records will be removed from this device.'**
  String get removeSamplesWarning;

  /// No description provided for @deleteAllWarning.
  ///
  /// In en, this message translates to:
  /// **'All saved scans will be removed from this device.'**
  String get deleteAllWarning;

  /// No description provided for @confirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get confirmTitle;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @aboutApp.
  ///
  /// In en, this message translates to:
  /// **'About the app'**
  String get aboutApp;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get appVersion;

  /// No description provided for @projectTitle.
  ///
  /// In en, this message translates to:
  /// **'Explainable AI based grape leaf disease detection and classification using deep learning'**
  String get projectTitle;

  /// No description provided for @privacyNote.
  ///
  /// In en, this message translates to:
  /// **'Scan results are stored only on this device.'**
  String get privacyNote;

  /// No description provided for @photoCheckTitle.
  ///
  /// In en, this message translates to:
  /// **'Check your photo'**
  String get photoCheckTitle;

  /// No description provided for @photoTooDark.
  ///
  /// In en, this message translates to:
  /// **'The photo looks dark. Move to better light.'**
  String get photoTooDark;

  /// No description provided for @photoTooBright.
  ///
  /// In en, this message translates to:
  /// **'The photo looks overexposed. Avoid direct glare.'**
  String get photoTooBright;

  /// No description provided for @photoNoLeaf.
  ///
  /// In en, this message translates to:
  /// **'A grape leaf may not be clearly visible. Fill the frame with one leaf.'**
  String get photoNoLeaf;

  /// No description provided for @useAnyway.
  ///
  /// In en, this message translates to:
  /// **'Use anyway'**
  String get useAnyway;

  /// No description provided for @retake.
  ///
  /// In en, this message translates to:
  /// **'Retake'**
  String get retake;

  /// No description provided for @pickFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not open the photo. Please try again.'**
  String get pickFailed;

  /// No description provided for @cameraNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'The camera is not available here. Choose a photo from the gallery.'**
  String get cameraNotAvailable;

  /// No description provided for @noPhotoYet.
  ///
  /// In en, this message translates to:
  /// **'No photo yet'**
  String get noPhotoYet;

  /// No description provided for @takeOrChoose.
  ///
  /// In en, this message translates to:
  /// **'Take a photo or choose one from your gallery'**
  String get takeOrChoose;

  /// No description provided for @demoPhotoNote.
  ///
  /// In en, this message translates to:
  /// **'Your photo is attached, but the demo classifier does not read it. The diagnosis shown is sample output.'**
  String get demoPhotoNote;

  /// No description provided for @heatmapNeedsModel.
  ///
  /// In en, this message translates to:
  /// **'The heatmap appears once the trained model is connected'**
  String get heatmapNeedsModel;

  /// No description provided for @weatherUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Weather is unavailable. Check your internet connection.'**
  String get weatherUnavailable;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @updatedAt.
  ///
  /// In en, this message translates to:
  /// **'Updated {time}'**
  String updatedAt(String time);

  /// No description provided for @usingSavedData.
  ///
  /// In en, this message translates to:
  /// **'Showing saved data'**
  String get usingSavedData;

  /// No description provided for @adviceHigh.
  ///
  /// In en, this message translates to:
  /// **'High risk of {disease} today. Inspect your vines.'**
  String adviceHigh(String disease);

  /// No description provided for @adviceModerate.
  ///
  /// In en, this message translates to:
  /// **'Moderate risk of {disease}. Keep checking your vines.'**
  String adviceModerate(String disease);

  /// No description provided for @adviceLow.
  ///
  /// In en, this message translates to:
  /// **'Conditions look low-risk for disease today.'**
  String get adviceLow;

  /// No description provided for @weatherEstimateNote.
  ///
  /// In en, this message translates to:
  /// **'Risk is estimated from the weather, not from your scans.'**
  String get weatherEstimateNote;

  /// No description provided for @wxClear.
  ///
  /// In en, this message translates to:
  /// **'Clear sky'**
  String get wxClear;

  /// No description provided for @wxPartlyCloudy.
  ///
  /// In en, this message translates to:
  /// **'Partly cloudy'**
  String get wxPartlyCloudy;

  /// No description provided for @wxCloudy.
  ///
  /// In en, this message translates to:
  /// **'Cloudy'**
  String get wxCloudy;

  /// No description provided for @wxFog.
  ///
  /// In en, this message translates to:
  /// **'Fog'**
  String get wxFog;

  /// No description provided for @wxDrizzle.
  ///
  /// In en, this message translates to:
  /// **'Drizzle'**
  String get wxDrizzle;

  /// No description provided for @wxRain.
  ///
  /// In en, this message translates to:
  /// **'Rain'**
  String get wxRain;

  /// No description provided for @wxStorm.
  ///
  /// In en, this message translates to:
  /// **'Thunderstorm'**
  String get wxStorm;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @overview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overview;

  /// No description provided for @noDetectionsYet.
  ///
  /// In en, this message translates to:
  /// **'No detections yet'**
  String get noDetectionsYet;

  /// No description provided for @noDetectionsMessage.
  ///
  /// In en, this message translates to:
  /// **'Scan a grape leaf to get started and save your results here.'**
  String get noDetectionsMessage;

  /// No description provided for @noMatchingScans.
  ///
  /// In en, this message translates to:
  /// **'No matching scans'**
  String get noMatchingScans;

  /// No description provided for @noMatchingHint.
  ///
  /// In en, this message translates to:
  /// **'Try a different name or switch the filter to All.'**
  String get noMatchingHint;

  /// No description provided for @searchByDisease.
  ///
  /// In en, this message translates to:
  /// **'Search by disease name'**
  String get searchByDisease;

  /// No description provided for @clearSearch.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get clearSearch;

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @removedItem.
  ///
  /// In en, this message translates to:
  /// **'{name} removed'**
  String removedItem(String name);

  /// No description provided for @percentHealthy.
  ///
  /// In en, this message translates to:
  /// **'{percent}% of scans are healthy'**
  String percentHealthy(int percent);

  /// No description provided for @noNewAlerts.
  ///
  /// In en, this message translates to:
  /// **'No new alerts'**
  String get noNewAlerts;

  /// No description provided for @alerts.
  ///
  /// In en, this message translates to:
  /// **'Alerts'**
  String get alerts;

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change language'**
  String get changeLanguage;

  /// No description provided for @aiLeafScan.
  ///
  /// In en, this message translates to:
  /// **'AI LEAF SCAN'**
  String get aiLeafScan;

  /// No description provided for @demoBadge.
  ///
  /// In en, this message translates to:
  /// **'DEMO'**
  String get demoBadge;

  /// No description provided for @sampleLabel.
  ///
  /// In en, this message translates to:
  /// **'sample'**
  String get sampleLabel;

  /// No description provided for @kmPerHour.
  ///
  /// In en, this message translates to:
  /// **'km/h'**
  String get kmPerHour;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @continueLabel.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueLabel;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @pageOf.
  ///
  /// In en, this message translates to:
  /// **'Page {current} of {total}'**
  String pageOf(int current, int total);

  /// No description provided for @onbDetectTag.
  ///
  /// In en, this message translates to:
  /// **'DETECT'**
  String get onbDetectTag;

  /// No description provided for @onbDetectTitle.
  ///
  /// In en, this message translates to:
  /// **'Spot leaf diseases early'**
  String get onbDetectTitle;

  /// No description provided for @onbDetectBody.
  ///
  /// In en, this message translates to:
  /// **'Scan a grape leaf with your camera or pick a photo from your gallery and get a likely diagnosis.'**
  String get onbDetectBody;

  /// No description provided for @onbDetectChip1.
  ///
  /// In en, this message translates to:
  /// **'Camera or gallery'**
  String get onbDetectChip1;

  /// No description provided for @onbDetectChip2.
  ///
  /// In en, this message translates to:
  /// **'Fast analysis'**
  String get onbDetectChip2;

  /// No description provided for @onbUnderstandTag.
  ///
  /// In en, this message translates to:
  /// **'UNDERSTAND'**
  String get onbUnderstandTag;

  /// No description provided for @onbUnderstandTitle.
  ///
  /// In en, this message translates to:
  /// **'See why the AI decided'**
  String get onbUnderstandTitle;

  /// No description provided for @onbUnderstandBody.
  ///
  /// In en, this message translates to:
  /// **'Explainable heatmaps highlight the parts of the leaf the model focused on, so you can check the result yourself.'**
  String get onbUnderstandBody;

  /// No description provided for @onbUnderstandChip1.
  ///
  /// In en, this message translates to:
  /// **'Heatmap overlay'**
  String get onbUnderstandChip1;

  /// No description provided for @onbCareTag.
  ///
  /// In en, this message translates to:
  /// **'CARE'**
  String get onbCareTag;

  /// No description provided for @onbCareTitle.
  ///
  /// In en, this message translates to:
  /// **'Get clear treatment tips'**
  String get onbCareTitle;

  /// No description provided for @onbCareBody.
  ///
  /// In en, this message translates to:
  /// **'Receive simple, step-by-step guidance for each disease and keep a history of every scan.'**
  String get onbCareBody;

  /// No description provided for @onbCareChip1.
  ///
  /// In en, this message translates to:
  /// **'Step-by-step care'**
  String get onbCareChip1;

  /// No description provided for @onbCareChip2.
  ///
  /// In en, this message translates to:
  /// **'Marathi & English'**
  String get onbCareChip2;

  /// No description provided for @result.
  ///
  /// In en, this message translates to:
  /// **'Result'**
  String get result;

  /// No description provided for @savedToHistory.
  ///
  /// In en, this message translates to:
  /// **'Saved to history'**
  String get savedToHistory;

  /// No description provided for @saved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get saved;

  /// No description provided for @careTips.
  ///
  /// In en, this message translates to:
  /// **'Care tips'**
  String get careTips;

  /// No description provided for @treatmentRecommendation.
  ///
  /// In en, this message translates to:
  /// **'Treatment recommendation'**
  String get treatmentRecommendation;

  /// No description provided for @aboutThisLeaf.
  ///
  /// In en, this message translates to:
  /// **'About this leaf'**
  String get aboutThisLeaf;

  /// No description provided for @symptomsToLookFor.
  ///
  /// In en, this message translates to:
  /// **'Symptoms to look for'**
  String get symptomsToLookFor;

  /// No description provided for @demoResultNote.
  ///
  /// In en, this message translates to:
  /// **'Demo result from the sample classifier. It is not a real diagnosis, and the heatmap below is a placeholder.'**
  String get demoResultNote;

  /// No description provided for @lowConfidenceNote.
  ///
  /// In en, this message translates to:
  /// **'The model is not very sure about this leaf. Retake the photo in good light with the leaf filling the frame.'**
  String get lowConfidenceNote;

  /// No description provided for @whatAiFocusedOn.
  ///
  /// In en, this message translates to:
  /// **'What the AI focused on'**
  String get whatAiFocusedOn;

  /// No description provided for @original.
  ///
  /// In en, this message translates to:
  /// **'Original'**
  String get original;

  /// No description provided for @gradCam.
  ///
  /// In en, this message translates to:
  /// **'Grad-CAM'**
  String get gradCam;

  /// No description provided for @sampleSuffix.
  ///
  /// In en, this message translates to:
  /// **'(SAMPLE)'**
  String get sampleSuffix;

  /// No description provided for @heatmapExplain.
  ///
  /// In en, this message translates to:
  /// **'Warm colours mark the leaf areas that influenced the prediction most. Real Grad-CAM heatmaps will appear here once the trained model is connected.'**
  String get heatmapExplain;

  /// No description provided for @topPredictions.
  ///
  /// In en, this message translates to:
  /// **'Top predictions'**
  String get topPredictions;

  /// No description provided for @guidanceDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'General guidance only. Confirm products and doses with the label and your local agriculture officer.'**
  String get guidanceDisclaimer;

  /// No description provided for @stepPreprocessing.
  ///
  /// In en, this message translates to:
  /// **'Preprocessing image'**
  String get stepPreprocessing;

  /// No description provided for @stepFeatures.
  ///
  /// In en, this message translates to:
  /// **'Feature extraction'**
  String get stepFeatures;

  /// No description provided for @stepPredicting.
  ///
  /// In en, this message translates to:
  /// **'Predicting disease'**
  String get stepPredicting;

  /// No description provided for @stepExplanation.
  ///
  /// In en, this message translates to:
  /// **'Generating explanation'**
  String get stepExplanation;

  /// No description provided for @placeLeafHint.
  ///
  /// In en, this message translates to:
  /// **'Place the leaf within the frame and keep it steady'**
  String get placeLeafHint;

  /// No description provided for @scanGrapeLeaf.
  ///
  /// In en, this message translates to:
  /// **'Scan Grape Leaf'**
  String get scanGrapeLeaf;

  /// No description provided for @flashOn.
  ///
  /// In en, this message translates to:
  /// **'Flash on'**
  String get flashOn;

  /// No description provided for @flashOff.
  ///
  /// In en, this message translates to:
  /// **'Flash off'**
  String get flashOff;

  /// No description provided for @captureLeaf.
  ///
  /// In en, this message translates to:
  /// **'Capture leaf'**
  String get captureLeaf;

  /// No description provided for @analyzingTitle.
  ///
  /// In en, this message translates to:
  /// **'Analyzing…'**
  String get analyzingTitle;

  /// No description provided for @analyzingHint.
  ///
  /// In en, this message translates to:
  /// **'This may take a few seconds. Please keep the leaf steady.'**
  String get analyzingHint;

  /// No description provided for @splashTagline.
  ///
  /// In en, this message translates to:
  /// **'Healthy Grapes  |  Better Harvests'**
  String get splashTagline;

  /// No description provided for @splashFooter.
  ///
  /// In en, this message translates to:
  /// **'EXPLAINABLE AI  ·  GRAPE LEAF DISEASE DETECTION'**
  String get splashFooter;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'mr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'mr':
      return AppLocalizationsMr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
