import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../features/diagnose/diagnose_page.dart';

class DiagnoseScreen extends StatelessWidget {
  final AppState appState;

  const DiagnoseScreen({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    return const DiagnosePage();
  }
}

