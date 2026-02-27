/// Maps car make names to their corresponding 3D GLB asset paths.
/// Only one GLB per brand to keep memory usage low.
const Map<String, String> carGlbMap = {
  'BMW': 'assets/cars/bmw_3series_optimized.glb',
  'Audi': 'assets/cars/3d_audi_optimized.glb',
  'Mercedes-Benz': 'assets/cars/mercedes_benz_optimized.glb',
  'Porsche': 'assets/cars/porsche_carrera_optimized.glb',
  'Ford': 'assets/cars/ford.glb',
};

/// Default GLB path used when no matching make is found.
const String defaultCarGlb = 'assets/cars/bmw_3series_optimized.glb';

/// Resolves the GLB path for a given car make.
String resolveCarGlb(String? make) {
  if (make == null || make.isEmpty) return defaultCarGlb;
  return carGlbMap[make] ?? defaultCarGlb;
}
