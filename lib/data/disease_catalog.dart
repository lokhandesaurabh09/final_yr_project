import '../models/disease.dart';

/// Disease knowledge base (English + Marathi).
///
/// IMPORTANT (team):
///  * The `id` values must match the class labels of the trained model
///    (labels.txt). Confirm names/order with whoever trains the model.
///  * Text is general viticulture guidance written for a prototype. Have it
///    reviewed against an agriculture-university / KVK source before
///    presenting it as advice.
///  * The Marathi text was machine-assisted and MUST be reviewed by a fluent
///    speaker (ideally an agriculture extension worker) before real use.
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
    aboutMr:
        'भुरी हा एरिसिफे नेकेटर (Erysiphe necator) या बुरशीमुळे होणारा रोग आहे. '
        'पाने, फुटवे आणि घडांवर पांढरट-राखाडी भुकटीसारखा थर तयार होतो. उबदार '
        'हवामान, रात्री दमटपणा आणि दाट, सावलीची वेल यामुळे तो झपाट्याने पसरतो.',
    symptoms: [
      'White or grey powdery patches on the leaf surface',
      'Leaves may curl, turn yellow or dry out',
      'Stunted shoot growth',
      'Infected berries can crack, split or stay hard and scarred',
    ],
    symptomsMr: [
      'पानाच्या पृष्ठभागावर पांढरे किंवा राखाडी भुकटीसारखे डाग',
      'पाने वळतात, पिवळी पडतात किंवा सुकतात',
      'फुटव्यांची वाढ खुंटते',
      'बाधित द्राक्षमणी तडकतात, फुटतात किंवा कडक व डागाळलेले राहतात',
    ],
    treatment: [
      'Remove and destroy badly infected leaves and shoots',
      'Open the canopy by pruning and shoot thinning for airflow and sunlight',
      'Use a sulfur-based or other fungicide approved for grapes, exactly as '
          'the product label directs',
      'Check neighbouring vines every week while the weather stays favourable',
    ],
    treatmentMr: [
      'जास्त बाधित पाने व फुटवे काढून नष्ट करा',
      'छाटणी व फुटवे विरळ करून वेलीत हवा खेळती व सूर्यप्रकाश येऊ द्या',
      'द्राक्षासाठी मान्यताप्राप्त गंधकयुक्त किंवा इतर बुरशीनाशक वापरा; '
          'फक्त औषधाच्या लेबलवरील सूचनेनुसार',
      'हवामान अनुकूल असेपर्यंत शेजारच्या वेली दर आठवड्याला तपासा',
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
    aboutMr:
        'केवडा हा प्लाझमोपारा व्हिटिकोला (Plasmopara viticola) मुळे होणारा रोग '
        'आहे. उबदार, ओलसर आणि दमट हवामानात तो वाढतो. पाने, फुटवे आणि कोवळ्या '
        'मण्यांवर परिणाम होतो आणि पावसानंतर तो वेगाने पसरू शकतो.',
    symptoms: [
      'Pale yellow, oily-looking spots on the upper leaf surface',
      'White downy growth on the underside of leaves in humid mornings',
      'Spots turn brown, leaves dry and drop early',
      'Young shoots and berries may curl or shrivel',
    ],
    symptomsMr: [
      'पानाच्या वरच्या बाजूला फिकट पिवळे, तेलकट दिसणारे डाग',
      'दमट सकाळी पानाच्या खालच्या बाजूला पांढरी कापसासारखी बुरशी',
      'डाग तपकिरी होतात, पाने सुकून लवकर गळतात',
      'कोवळे फुटवे व मणी वळतात किंवा सुकतात',
    ],
    treatment: [
      'Remove infected leaves and shoots and keep them away from the vineyard',
      'Improve airflow, avoid overhead irrigation and keep leaves dry',
      'Use a copper-based or other fungicide approved for grapes, as the '
          'label directs, preferably before wet spells',
      'Avoid working among the vines while the leaves are wet',
    ],
    treatmentMr: [
      'बाधित पाने व फुटवे काढून बागेपासून दूर नष्ट करा',
      'हवा खेळती ठेवा, वरून पाणी देणे टाळा आणि पाने कोरडी ठेवा',
      'द्राक्षासाठी मान्यताप्राप्त तांबेयुक्त किंवा इतर बुरशीनाशक लेबलप्रमाणे '
          'वापरा, शक्यतो पावसाळी वातावरणापूर्वी',
      'पाने ओली असताना वेलींमध्ये काम करणे टाळा',
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
    aboutMr:
        'काळी कूज हा बुरशीजन्य रोग असून त्यामुळे पानांवर ठिपके पडतात आणि मणी '
        'कडक, सुकलेल्या काळ्या ममींसारखे होतात. उबदार व ओलसर हवामानात '
        'उत्पादनाचे मोठे नुकसान होते.',
    symptoms: [
      'Small reddish-brown circular spots with dark borders on leaves',
      'Tiny black dots inside older spots',
      'Berries rot and shrivel into hard black mummies',
      'Dark lesions on shoots and tendrils',
    ],
    symptomsMr: [
      'पानांवर गडद कडा असलेले लालसर-तपकिरी गोल ठिपके',
      'जुन्या ठिपक्यांमध्ये लहान काळे बिंदू',
      'मणी कुजतात आणि सुकून कडक काळे होतात',
      'फुटवे व तंतूंवर गडद व्रण',
    ],
    treatment: [
      'Remove and destroy mummified berries, infected leaves and prunings',
      'Open the canopy so leaves dry quickly after rain',
      'Use a protective fungicide approved for grapes from early in the '
          'season, following the label',
      'Keep the ground under the vines free of fallen fruit and leaves',
    ],
    treatmentMr: [
      'सुकलेले मणी, बाधित पाने व छाटलेला भाग काढून नष्ट करा',
      'वेलीत हवा खेळती ठेवा, म्हणजे पावसानंतर पाने लवकर कोरडी होतील',
      'हंगामाच्या सुरुवातीपासून द्राक्षासाठी मान्यताप्राप्त संरक्षक '
          'बुरशीनाशक लेबलप्रमाणे वापरा',
      'वेलींखालची जमीन गळलेली फळे व पानांपासून स्वच्छ ठेवा',
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
    aboutMr:
        'पानांवरील करपा (इसारिओप्सिस पानांवरील ठिपके रोग) हा बुरशीजन्य रोग आहे. '
        'गडद ठिपके एकमेकांत मिसळतात आणि जास्त प्रादुर्भावात पाने लवकर गळून '
        'वेल कमजोर होते.',
    symptoms: [
      'Dark brown to black irregular spots, often with yellow edges',
      'Spots join into larger dead patches',
      'Leaves dry out and fall early',
      'Most common on older leaves late in the season',
    ],
    symptomsMr: [
      'गडद तपकिरी ते काळे अनियमित ठिपके; कडा अनेकदा पिवळ्या',
      'ठिपके एकत्र येऊन मोठे मृत भाग तयार होतात',
      'पाने सुकून लवकर गळतात',
      'हंगामाच्या शेवटी जुन्या पानांवर जास्त आढळतो',
    ],
    treatment: [
      'Remove and destroy infected leaves',
      'Improve air circulation and avoid wetting the leaves when irrigating',
      'Use a fungicide approved for grapes as advised by your local '
          'agriculture officer, following the label',
      'Clear fallen leaves from the vineyard floor',
    ],
    treatmentMr: [
      'बाधित पाने काढून नष्ट करा',
      'हवा खेळती ठेवा आणि पाणी देताना पाने ओली करू नका',
      'स्थानिक कृषी अधिकाऱ्याच्या सल्ल्याने द्राक्षासाठी मान्यताप्राप्त '
          'बुरशीनाशक लेबलप्रमाणे वापरा',
      'बागेतील जमिनीवरील गळलेली पाने साफ करा',
    ],
  );

  static const Disease healthy = Disease(
    id: 'healthy',
    nameEn: 'Healthy Leaf',
    nameMr: 'निरोगी पान',
    scientificName: 'No disease detected',
    isHealthy: true,
    about: 'No signs of disease were detected on this leaf.',
    aboutMr: 'या पानावर रोगाची कोणतीही लक्षणे आढळली नाहीत.',
    symptoms: [],
    treatment: [
      'Keep checking leaves regularly, especially after rain',
      'Maintain good airflow through pruning and shoot thinning',
      'Water at the base of the vine and avoid wetting the leaves',
      'Scan again if you notice spots, powder or discolouration',
    ],
    treatmentMr: [
      'पाने नियमितपणे तपासा, विशेषतः पावसानंतर',
      'छाटणी व फुटवे विरळ करून हवा खेळती ठेवा',
      'वेलीच्या बुडाशी पाणी द्या आणि पाने ओली करू नका',
      'डाग, भुकटी किंवा रंग बदल दिसल्यास पुन्हा स्कॅन करा',
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
