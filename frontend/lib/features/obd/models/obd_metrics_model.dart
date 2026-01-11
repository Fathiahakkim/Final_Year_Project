class OBDMetricsModel {
  final double rpm;
  final double coolantTemp; // in Fahrenheit
  final double batteryVoltage;
  final double throttlePosition; // percentage

  const OBDMetricsModel({
    required this.rpm,
    required this.coolantTemp,
    required this.batteryVoltage,
    required this.throttlePosition,
  });
}
