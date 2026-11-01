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
 
  const Disease({
    required this.id,
    required this.nameEn,
    required this.nameMr,
    required this.scientificName,
    this.isHealthy = false,
    required this.about,
    required this.symptoms,
    required this.treatment,
  });
 
  String name(String languageCode) => languageCode == 'mr' ? nameMr : nameEn;
 
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