class OBDDTCModel {
  final String code;
  final String description;
  final int severity; // 0-100

  const OBDDTCModel({
    required this.code,
    required this.description,
    required this.severity,
  });
}
