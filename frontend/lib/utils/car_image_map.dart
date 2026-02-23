/// Maps car make_model keys to their corresponding asset image paths.
/// Key format: "${make}_${model}" (e.g., "Toyota_Camry")
const Map<String, String> carImageMap = {
  // Toyota models
  'Toyota_Corolla': 'assets/cars/toyoto_corolla.png',
  'Toyota_Camry': 'assets/cars/camry_toyota.png',

  // Honda models
  'Honda_Civic': 'assets/cars/honda.png',
  'Honda_Accord': 'assets/cars/honda.png',
  'Honda_CR-V': 'assets/cars/honda.png',
  'Honda_Pilot': 'assets/cars/honda.png',
  'Honda_Odyssey': 'assets/cars/honda.png',
  'Honda_Fit': 'assets/cars/honda.png',
  'Honda_HR-V': 'assets/cars/honda.png',
  'Honda_Passport': 'assets/cars/honda.png',
  'Honda_Ridgeline': 'assets/cars/honda.png',
  'Honda_Insight': 'assets/cars/honda.png',

  // BMW models
  'BMW_3 Series': 'assets/cars/bmw.png',
  'BMW_5 Series': 'assets/cars/bmw.png',
  'BMW_X3': 'assets/cars/bmw.png',
  'BMW_X5': 'assets/cars/bmw.png',
  'BMW_X1': 'assets/cars/bmw.png',
  'BMW_7 Series': 'assets/cars/bmw.png',
  'BMW_X7': 'assets/cars/bmw.png',
  'BMW_4 Series': 'assets/cars/bmw.png',
  'BMW_iX': 'assets/cars/bmw.png',
  'BMW_Z4': 'assets/cars/bmw.png',

  // Hyundai models
  'Hyundai_Elantra': 'assets/cars/hyundai.jpg',
  'Hyundai_Sonata': 'assets/cars/hyundai.jpg',
  'Hyundai_Tucson': 'assets/cars/hyundai.jpg',
  'Hyundai_Santa Fe': 'assets/cars/hyundai.jpg',
  'Hyundai_Palisade': 'assets/cars/hyundai.jpg',
  'Hyundai_Kona': 'assets/cars/hyundai.jpg',
  'Hyundai_Venue': 'assets/cars/hyundai.jpg',
  'Hyundai_Ioniq': 'assets/cars/hyundai.jpg',
  'Hyundai_Genesis': 'assets/cars/hyundai.jpg',
  'Hyundai_Veloster': 'assets/cars/hyundai.jpg',
};

/// Default image path used when no matching car image is found.
const String defaultCarImage = 'assets/cars/default_car.jpg';
