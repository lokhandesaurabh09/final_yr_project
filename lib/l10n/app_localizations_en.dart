// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'VineGuard';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get history => 'History';

  @override
  String get scanLeaf => 'Scan Leaf';

  @override
  String get recentScans => 'Recent Scans';

  @override
  String get diseaseDetected => 'Disease Detected';

  @override
  String get healthy => 'Healthy';

  @override
  String get scans => 'Scans';

  @override
  String get diseases => 'Diseases';

  @override
  String get confidence => 'Confidence';

  @override
  String get severity => 'Severity';

  @override
  String get about => 'About';

  @override
  String get symptoms => 'Symptoms';

  @override
  String get treatment => 'Treatment';

  @override
  String get scanNow => 'Scan a leaf now';

  @override
  String get tapCamera => 'Tap the camera button below';

  @override
  String get goodMorning => 'Good morning 👋';

  @override
  String get vineyardHealth => 'Vineyard health overview';

  @override
  String get vineyardWeather => 'Vineyard Weather';

  @override
  String get humidity => 'Humidity';

  @override
  String get wind => 'Wind';

  @override
  String get feelsLike => 'Feels like';

  @override
  String get diseaseRiskIndex => 'Disease Risk Index';

  @override
  String get viewAll => 'View all →';

  @override
  String get saveResult => 'Save';

  @override
  String get backToDashboard => 'Back to Dashboard';

  @override
  String get analyzing => 'Analyzing leaf...';

  @override
  String get centerLeaf => 'Center a grape leaf in the frame';

  @override
  String get scanHistory => 'Scan History';

  @override
  String get total => 'Total';

  @override
  String get diseased => 'Diseased';

  @override
  String get thisWeek => 'This week';

  @override
  String get moderate => 'Moderate';

  @override
  String get severe => 'Severe';

  @override
  String get mild => 'Mild';

  @override
  String get noDisease => 'No disease';

  @override
  String get gallery => 'Gallery';

  @override
  String get flip => 'Flip';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get settings => 'Settings';

  @override
  String get guide => 'Guide';

  @override
  String get guideSubtitle => 'Learn to recognise common grape leaf problems';

  @override
  String get language => 'Language';

  @override
  String get theme => 'Theme';

  @override
  String get themeLight => 'Light';

  @override
  String get darkModeSoon => 'Dark mode is coming soon';

  @override
  String get appSettings => 'App settings';

  @override
  String get modelAndData => 'Model & data';

  @override
  String get modelName => 'Model';

  @override
  String get demoModelNote =>
      'Results come from a demo classifier. The trained model is not connected yet.';

  @override
  String get savedScans => 'Saved scans';

  @override
  String get sampleRecords => 'Sample records';

  @override
  String get removeSamples => 'Remove sample records';

  @override
  String get addSamples => 'Add sample records';

  @override
  String get deleteAllScans => 'Delete all scans';

  @override
  String get removeSamplesWarning =>
      'The sample records will be removed from this device.';

  @override
  String get deleteAllWarning =>
      'All saved scans will be removed from this device.';

  @override
  String get confirmTitle => 'Are you sure?';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get done => 'Done';

  @override
  String get aboutApp => 'About the app';

  @override
  String get appVersion => 'Version';

  @override
  String get projectTitle =>
      'Explainable AI based grape leaf disease detection and classification using deep learning';

  @override
  String get privacyNote => 'Scan results are stored only on this device.';

  @override
  String get photoCheckTitle => 'Check your photo';

  @override
  String get photoTooDark => 'The photo looks dark. Move to better light.';

  @override
  String get photoTooBright =>
      'The photo looks overexposed. Avoid direct glare.';

  @override
  String get photoNoLeaf =>
      'A grape leaf may not be clearly visible. Fill the frame with one leaf.';

  @override
  String get useAnyway => 'Use anyway';

  @override
  String get retake => 'Retake';

  @override
  String get pickFailed => 'Could not open the photo. Please try again.';

  @override
  String get cameraNotAvailable =>
      'The camera is not available here. Choose a photo from the gallery.';

  @override
  String get noPhotoYet => 'No photo yet';

  @override
  String get takeOrChoose => 'Take a photo or choose one from your gallery';

  @override
  String get demoPhotoNote =>
      'Your photo is attached, but the demo classifier does not read it. The diagnosis shown is sample output.';

  @override
  String get heatmapNeedsModel =>
      'The heatmap appears once the trained model is connected';

  @override
  String get weatherUnavailable =>
      'Weather is unavailable. Check your internet connection.';

  @override
  String get retry => 'Retry';

  @override
  String updatedAt(String time) {
    return 'Updated $time';
  }

  @override
  String get usingSavedData => 'Showing saved data';

  @override
  String adviceHigh(String disease) {
    return 'High risk of $disease today. Inspect your vines.';
  }

  @override
  String adviceModerate(String disease) {
    return 'Moderate risk of $disease. Keep checking your vines.';
  }

  @override
  String get adviceLow => 'Conditions look low-risk for disease today.';

  @override
  String get weatherEstimateNote =>
      'Risk is estimated from the weather, not from your scans.';

  @override
  String get wxClear => 'Clear sky';

  @override
  String get wxPartlyCloudy => 'Partly cloudy';

  @override
  String get wxCloudy => 'Cloudy';

  @override
  String get wxFog => 'Fog';

  @override
  String get wxDrizzle => 'Drizzle';

  @override
  String get wxRain => 'Rain';

  @override
  String get wxStorm => 'Thunderstorm';

  @override
  String get all => 'All';

  @override
  String get overview => 'Overview';

  @override
  String get noDetectionsYet => 'No detections yet';

  @override
  String get noDetectionsMessage =>
      'Scan a grape leaf to get started and save your results here.';

  @override
  String get noMatchingScans => 'No matching scans';

  @override
  String get noMatchingHint =>
      'Try a different name or switch the filter to All.';

  @override
  String get searchByDisease => 'Search by disease name';

  @override
  String get clearSearch => 'Clear search';

  @override
  String get undo => 'Undo';

  @override
  String removedItem(String name) {
    return '$name removed';
  }

  @override
  String percentHealthy(int percent) {
    return '$percent% of scans are healthy';
  }

  @override
  String get noNewAlerts => 'No new alerts';

  @override
  String get alerts => 'Alerts';

  @override
  String get changeLanguage => 'Change language';

  @override
  String get aiLeafScan => 'AI LEAF SCAN';

  @override
  String get demoBadge => 'DEMO';

  @override
  String get sampleLabel => 'sample';

  @override
  String get kmPerHour => 'km/h';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get back => 'Back';

  @override
  String get skip => 'Skip';

  @override
  String get continueLabel => 'Continue';

  @override
  String get getStarted => 'Get Started';

  @override
  String pageOf(int current, int total) {
    return 'Page $current of $total';
  }

  @override
  String get onbDetectTag => 'DETECT';

  @override
  String get onbDetectTitle => 'Spot leaf diseases early';

  @override
  String get onbDetectBody =>
      'Scan a grape leaf with your camera or pick a photo from your gallery and get a likely diagnosis.';

  @override
  String get onbDetectChip1 => 'Camera or gallery';

  @override
  String get onbDetectChip2 => 'Fast analysis';

  @override
  String get onbUnderstandTag => 'UNDERSTAND';

  @override
  String get onbUnderstandTitle => 'See why the AI decided';

  @override
  String get onbUnderstandBody =>
      'Explainable heatmaps highlight the parts of the leaf the model focused on, so you can check the result yourself.';

  @override
  String get onbUnderstandChip1 => 'Heatmap overlay';

  @override
  String get onbCareTag => 'CARE';

  @override
  String get onbCareTitle => 'Get clear treatment tips';

  @override
  String get onbCareBody =>
      'Receive simple, step-by-step guidance for each disease and keep a history of every scan.';

  @override
  String get onbCareChip1 => 'Step-by-step care';

  @override
  String get onbCareChip2 => 'Marathi & English';

  @override
  String get result => 'Result';

  @override
  String get savedToHistory => 'Saved to history';

  @override
  String get saved => 'Saved';

  @override
  String get careTips => 'Care tips';

  @override
  String get treatmentRecommendation => 'Treatment recommendation';

  @override
  String get aboutThisLeaf => 'About this leaf';

  @override
  String get symptomsToLookFor => 'Symptoms to look for';

  @override
  String get demoResultNote =>
      'Demo result from the sample classifier. It is not a real diagnosis, and the heatmap below is a placeholder.';

  @override
  String get lowConfidenceNote =>
      'The model is not very sure about this leaf. Retake the photo in good light with the leaf filling the frame.';

  @override
  String get whatAiFocusedOn => 'What the AI focused on';

  @override
  String get original => 'Original';

  @override
  String get gradCam => 'Grad-CAM';

  @override
  String get sampleSuffix => '(SAMPLE)';

  @override
  String get heatmapExplain =>
      'Warm colours mark the leaf areas that influenced the prediction most. Real Grad-CAM heatmaps will appear here once the trained model is connected.';

  @override
  String get topPredictions => 'Top predictions';

  @override
  String get guidanceDisclaimer =>
      'General guidance only. Confirm products and doses with the label and your local agriculture officer.';

  @override
  String get stepPreprocessing => 'Preprocessing image';

  @override
  String get stepFeatures => 'Feature extraction';

  @override
  String get stepPredicting => 'Predicting disease';

  @override
  String get stepExplanation => 'Generating explanation';

  @override
  String get placeLeafHint =>
      'Place the leaf within the frame and keep it steady';

  @override
  String get scanGrapeLeaf => 'Scan Grape Leaf';

  @override
  String get flashOn => 'Flash on';

  @override
  String get flashOff => 'Flash off';

  @override
  String get captureLeaf => 'Capture leaf';

  @override
  String get analyzingTitle => 'Analyzing…';

  @override
  String get analyzingHint =>
      'This may take a few seconds. Please keep the leaf steady.';

  @override
  String get splashTagline => 'Healthy Grapes  |  Better Harvests';

  @override
  String get splashFooter => 'EXPLAINABLE AI  ·  GRAPE LEAF DISEASE DETECTION';
}
