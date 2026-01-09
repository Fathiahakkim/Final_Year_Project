import 'package:flutter/material.dart';
import '../state/app_state.dart';

class OBDDataScreen extends StatelessWidget {
  final AppState appState;

  const OBDDataScreen({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OBD Data'),
      ),
      body: const Center(
        child: Text('OBD Data Screen'),
      ),
    );
  }
}
