import 'package:flutter/material.dart';
import '../theme/obd_theme.dart';
import '../models/obd_dtc_model.dart';

class DTCCodeItem extends StatelessWidget {
  final OBDDTCModel dtc;

  const DTCCodeItem({
    super.key,
    required this.dtc,
  });

  Color get _severityColor {
    if (dtc.severity >= 80) {
      return OBDTheme.dtcErrorColor;
    } else if (dtc.severity >= 50) {
      return OBDTheme.dtcWarningColor;
    } else {
      return OBDTheme.accentBlue;
    }
  }

  IconData get _severityIcon {
    if (dtc.severity >= 80) {
      return Icons.local_fire_department; // Flame icon for high severity
    } else if (dtc.severity >= 50) {
      return Icons.warning_amber;
    } else {
      return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: OBDTheme.dtcItemHeight,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: OBDTheme.cardWhite,
        borderRadius: BorderRadius.circular(OBDTheme.dtcItemRadius),
        boxShadow: OBDTheme.metricPanelShadow,
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 3),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _severityColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    _severityIcon,
                    color: _severityColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        dtc.code,
                        style: TextStyle(
                          fontSize: OBDTheme.dtcCodeFontSize,
                          fontWeight: FontWeight.bold,
                          color: OBDTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        dtc.description,
                        style: TextStyle(
                          fontSize: OBDTheme.dtcDescriptionFontSize,
                          color: OBDTheme.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Text(
                  '${dtc.severity}%',
                  style: TextStyle(
                    fontSize: OBDTheme.dtcCodeFontSize,
                    fontWeight: FontWeight.w600,
                    color: _severityColor,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: OBDTheme.textSecondary,
                ),
              ],
            ),
          ),
          // Progress bar at bottom
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(OBDTheme.dtcItemRadius),
                bottomRight: Radius.circular(OBDTheme.dtcItemRadius),
              ),
              child: LinearProgressIndicator(
                value: dtc.severity / 100,
                minHeight: 3,
                backgroundColor: _severityColor.withOpacity(0.2),
                valueColor: AlwaysStoppedAnimation<Color>(_severityColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
