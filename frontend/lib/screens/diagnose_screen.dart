import 'package:flutter/material.dart';
import '../state/app_state.dart';

class DiagnoseScreen extends StatelessWidget {
  final AppState appState;

  const DiagnoseScreen({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diagnose'),
      ),
      body: const Center(
        child: Text('Diagnose Screen'),
      ),
    );
  }
}

