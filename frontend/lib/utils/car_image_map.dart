/// Maps car make_model keys to their corresponding asset image paths.
/// Key format: "${make}_${model}" (e.g., "BMW_3 Series")
const Map<String, String> carImageMap = {
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

  // Mercedes-Benz models
  'Mercedes-Benz_C-Class': 'assets/cars/benz.webp',
  'Mercedes-Benz_E-Class': 'assets/cars/benz.webp',
  'Mercedes-Benz_S-Class': 'assets/cars/benz.webp',
  'Mercedes-Benz_GLE': 'assets/cars/benz.webp',
  'Mercedes-Benz_GLC': 'assets/cars/benz.webp',
  'Mercedes-Benz_GLS': 'assets/cars/benz.webp',
  'Mercedes-Benz_A-Class': 'assets/cars/benz.webp',
  'Mercedes-Benz_G-Class': 'assets/cars/benz.webp',
  'Mercedes-Benz_CLA': 'assets/cars/benz.webp',
  'Mercedes-Benz_AMG GT': 'assets/cars/benz.webp',

  // Audi models
  'Audi_A4': 'assets/cars/audia4.webp',
  'Audi_A6': 'assets/cars/audia4.webp',
  'Audi_Q5': 'assets/cars/audia4.webp',
  'Audi_Q7': 'assets/cars/audia4.webp',
  'Audi_Q3': 'assets/cars/audia4.webp',
  'Audi_A3': 'assets/cars/audia4.webp',
  'Audi_e-tron': 'assets/cars/audia4.webp',
  'Audi_TT': 'assets/cars/audia4.webp',
  'Audi_A8': 'assets/cars/audia4.webp',
  'Audi_Q8': 'assets/cars/audia4.webp',

  // Porsche models
  'Porsche_911': 'assets/cars/porsche.webp',
  'Porsche_Cayenne': 'assets/cars/porsche.webp',
  'Porsche_Macan': 'assets/cars/porsche.webp',
  'Porsche_Panamera': 'assets/cars/porsche.webp',
  'Porsche_Taycan': 'assets/cars/porsche.webp',
  'Porsche_718 Cayman': 'assets/cars/porsche.webp',
  'Porsche_718 Boxster': 'assets/cars/porsche.webp',

  // Ford models
  'Ford_F-150': 'assets/cars/ford_img.webp',
  'Ford_Escape': 'assets/cars/ford_img.webp',
  'Ford_Explorer': 'assets/cars/ford_img.webp',
  'Ford_Mustang': 'assets/cars/ford_img.webp',
  'Ford_Edge': 'assets/cars/ford_img.webp',
  'Ford_Expedition': 'assets/cars/ford_img.webp',
  'Ford_Ranger': 'assets/cars/ford_img.webp',
  'Ford_Fusion': 'assets/cars/ford_img.webp',
  'Ford_Bronco': 'assets/cars/ford_img.webp',
  'Ford_Maverick': 'assets/cars/ford_img.webp',
};

/// Default image path used when no matching car image is found.
const String defaultCarImage = 'assets/cars/bmw.png';
