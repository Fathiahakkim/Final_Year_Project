import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../features/obd/obd_page.dart';

class OBDDataScreen extends StatelessWidget {
  final AppState appState;
  final VoidCallback? onNavigateHome;

  const OBDDataScreen({super.key, required this.appState, this.onNavigateHome});

  @override
  Widget build(BuildContext context) {
    return OBDPage(appState: appState, onNavigateHome: onNavigateHome);
  }
}
