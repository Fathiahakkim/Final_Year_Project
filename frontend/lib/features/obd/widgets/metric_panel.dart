import 'package:flutter/material.dart';
import '../theme/obd_theme.dart';

enum MetricType {
  rpm,
  coolantTemp,
  batteryVoltage,
  throttlePosition,
}

class MetricPanel extends StatelessWidget {
  final MetricType type;
  final String value;
  final double progress; // 0.0 to 1.0
  final IconData icon;

  const MetricPanel({
    super.key,
    required this.type,
    required this.value,
    required this.progress,
    required this.icon,
  });

  Color get _metricColor {
    switch (type) {
      case MetricType.rpm:
        return OBDTheme.rpmColor;
      case MetricType.coolantTemp:
        return OBDTheme.tempColor;
      case MetricType.batteryVoltage:
        return OBDTheme.voltageColor;
      case MetricType.throttlePosition:
        return OBDTheme.throttleColor;
    }
  }

  String get _label {
    switch (type) {
      case MetricType.rpm:
        return 'RPM';
      case MetricType.coolantTemp:
        return 'Coolant Temp';
      case MetricType.batteryVoltage:
        return 'Battery Voltage';
      case MetricType.throttlePosition:
        return 'Throttle Position';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: OBDTheme.metricPanelHeight,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: OBDTheme.cardWhite,
          borderRadius: BorderRadius.circular(OBDTheme.metricPanelRadius),
          boxShadow: OBDTheme.metricPanelShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: _metricColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    icon,
                    color: _metricColor,
                    size: 20,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              value,
              style: TextStyle(
                fontSize: OBDTheme.metricValueFontSize,
                fontWeight: FontWeight.bold,
                color: OBDTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _label,
              style: TextStyle(
                fontSize: OBDTheme.metricLabelFontSize,
                color: OBDTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: OBDTheme.progressBarHeight,
                backgroundColor: _metricColor.withOpacity(0.2),
                valueColor: AlwaysStoppedAnimation<Color>(_metricColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
