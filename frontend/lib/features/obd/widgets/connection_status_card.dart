import 'package:flutter/material.dart';
import '../theme/obd_theme.dart';
import '../controllers/obd_controller.dart';

class ConnectionStatusCard extends StatelessWidget {
  final OBDController controller;

  const ConnectionStatusCard({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: controller.isConnected,
      builder: (context, isConnected, child) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: OBDTheme.cardWhite,
            borderRadius: BorderRadius.circular(OBDTheme.cardRadius),
            boxShadow: OBDTheme.cardShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Car OBD-II Adapter Connected',
                style: TextStyle(
                  color: OBDTheme.textSecondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: OBDTheme.connectedGreen,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Simulated',
                    style: TextStyle(
                      color: OBDTheme.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
