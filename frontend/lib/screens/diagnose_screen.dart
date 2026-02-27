import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../features/diagnose/diagnose_page.dart';

class DiagnoseScreen extends StatelessWidget {
  final AppState appState;
  final VoidCallback? onNavigateHome;

  const DiagnoseScreen({super.key, required this.appState, this.onNavigateHome});

  @override
  Widget build(BuildContext context) {
    return DiagnosePage(appState: appState, onNavigateHome: onNavigateHome);
  }
}
