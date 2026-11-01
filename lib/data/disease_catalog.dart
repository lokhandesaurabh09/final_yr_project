import '../models/disease.dart';
 
/// Disease knowledge base.
///
/// IMPORTANT (team):
///  * The `id` values must match the class labels of the trained model
///    (labels.txt). Confirm names/order with whoever trains the model.
///  * Text is general viticulture guidance written for a prototype. Have it
///    reviewed against an agriculture-university / KVK source before
///    presenting it as advice. Marathi names need native-speaker review.
///  * No doses or spray intervals are given on purpose: they must come from
///    the product label / a local agriculture officer.
class DiseaseCatalog {
  static const Disease powderyMildew = Disease(
    id: 'powdery_mildew',
    nameEn: 'Powdery Mildew',
    nameMr: 'भुरी रोग',
    scientificName: 'Erysiphe necator',
    about:
        'Powdery mildew is a fungal disease caused by Erysiphe necator. It '
        'forms a white to grey powdery coating on leaves, shoots and berries '
        'and spreads in warm weather with humid nights and dense, shaded '
        'canopies.',
    symptoms: [
      'White or grey powdery patches on the leaf surface',
      'Leaves may curl, turn yellow or dry out',
      'Stunted shoot growth',
      'Infected berries can crack, split or stay hard and scarred',
    ],
    treatment: [
      'Remove and destroy badly infected leaves and shoots',
      'Open the canopy by pruning and shoot thinning for airflow and sunlight',
      'Use a sulfur-based or other fungicide approved for grapes, exactly as '
          'the product label directs',
      'Check neighbouring vines every week while the weather stays favourable',
    ],
  );
 
  static const Disease downyMildew = Disease(
    id: 'downy_mildew',
    nameEn: 'Downy Mildew',
    nameMr: 'केवडा रोग',
    scientificName: 'Plasmopara viticola',
    about:
        'Downy mildew is caused by Plasmopara viticola, which thrives in warm, '
        'wet and humid weather. It attacks leaves, shoots and young berries '
        'and can spread quickly after rain.',
    symptoms: [
      'Pale yellow, oily-looking spots on the upper leaf surface',
      'White downy growth on the underside of leaves in humid mornings',
      'Spots turn brown, leaves dry and drop early',
      'Young shoots and berries may curl or shrivel',
    ],
    treatment: [
      'Remove infected leaves and shoots and keep them away from the vineyard',
      'Improve airflow, avoid overhead irrigation and keep leaves dry',
      'Use a copper-based or other fungicide approved for grapes, as the '
          'label directs, preferably before wet spells',
      'Avoid working among the vines while the leaves are wet',
    ],
  );
 
  static const Disease blackRot = Disease(
    id: 'black_rot',
    nameEn: 'Black Rot',
    nameMr: 'काळी कूज',
    scientificName: 'Phyllosticta ampelicida',
    about:
        'Black rot is a fungal disease that causes leaf spots and can turn '
        'berries into hard, shrivelled black mummies. It causes heavy crop '
        'loss in warm, wet weather.',
    symptoms: [
      'Small reddish-brown circular spots with dark borders on leaves',
      'Tiny black dots inside older spots',
      'Berries rot and shrivel into hard black mummies',
      'Dark lesions on shoots and tendrils',
    ],
    treatment: [
      'Remove and destroy mummified berries, infected leaves and prunings',
      'Open the canopy so leaves dry quickly after rain',
      'Use a protective fungicide approved for grapes from early in the '
          'season, following the label',
      'Keep the ground under the vines free of fallen fruit and leaves',
    ],
  );
 
  static const Disease leafBlight = Disease(
    id: 'leaf_blight',
    nameEn: 'Leaf Blight',
    nameMr: 'पानांवरील करपा',
    scientificName: 'Pseudocercospora vitis',
    about:
        'Leaf blight (also called Isariopsis leaf spot) is a fungal leaf '
        'disease. It causes dark spots that join together, and heavy '
        'infection can make leaves fall early and weaken the vine.',
    symptoms: [
      'Dark brown to black irregular spots, often with yellow edges',
      'Spots join into larger dead patches',
      'Leaves dry out and fall early',
      'Most common on older leaves late in the season',
    ],
    treatment: [
      'Remove and destroy infected leaves',
      'Improve air circulation and avoid wetting the leaves when irrigating',
      'Use a fungicide approved for grapes as advised by your local '
          'agriculture officer, following the label',
      'Clear fallen leaves from the vineyard floor',
    ],
  );
 
  static const Disease healthy = Disease(
    id: 'healthy',
    nameEn: 'Healthy Leaf',
    nameMr: 'निरोगी पान',
    scientificName: 'No disease detected',
    isHealthy: true,
    about: 'No signs of disease were detected on this leaf.',
    symptoms: [],
    treatment: [
      'Keep checking leaves regularly, especially after rain',
      'Maintain good airflow through pruning and shoot thinning',
      'Water at the base of the vine and avoid wetting the leaves',
      'Scan again if you notice spots, powder or discolouration',
    ],
  );
 
  static const List<Disease> all = [
    powderyMildew,
    downyMildew,
    blackRot,
    leafBlight,
    healthy,
  ];
 
  static Disease byId(String id) =>
      all.firstWhere((d) => d.id == id, orElse: () => Disease.unknown);
}
 