import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../features/obd/obd_page.dart';

class OBDDataScreen extends StatelessWidget {
  final AppState appState;

  const OBDDataScreen({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    return const OBDPage();
  }
}
