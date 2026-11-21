/// Static knowledge about one disease class (shown on Result / Guide screens).
class Disease {
  final String id;
  final String nameEn;
  final String nameMr;
  final String scientificName;
  final bool isHealthy;

  final String about;
  final List<String> symptoms;

  /// Treatment steps (or care tips for the healthy class).
  final List<String> treatment;

  /// Marathi versions. If empty, the English text is shown instead.
  final String aboutMr;
  final List<String> symptomsMr;
  final List<String> treatmentMr;

  const Disease({
    required this.id,
    required this.nameEn,
    required this.nameMr,
    required this.scientificName,
    this.isHealthy = false,
    required this.about,
    required this.symptoms,
    required this.treatment,
    this.aboutMr = '',
    this.symptomsMr = const [],
    this.treatmentMr = const [],
  });

  bool _mr(String lang) => lang == 'mr';

  String name(String lang) => _mr(lang) ? nameMr : nameEn;

  String aboutFor(String lang) =>
      _mr(lang) && aboutMr.isNotEmpty ? aboutMr : about;

  List<String> symptomsFor(String lang) =>
      _mr(lang) && symptomsMr.isNotEmpty ? symptomsMr : symptoms;

  List<String> treatmentFor(String lang) =>
      _mr(lang) && treatmentMr.isNotEmpty ? treatmentMr : treatment;

  static const Disease unknown = Disease(
    id: 'unknown',
    nameEn: 'Unknown',
    nameMr: 'अज्ञात',
    scientificName: '',
    about: 'This class is not in the disease catalog yet.',
    symptoms: [],
    treatment: [],
  );
}
