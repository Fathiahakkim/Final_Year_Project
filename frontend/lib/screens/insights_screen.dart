import 'package:flutter/material.dart';
import '../state/app_state.dart';

class InsightsScreen extends StatelessWidget {
  final AppState appState;

  const InsightsScreen({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Insights'),
      ),
      body: const Center(
        child: Text('Insights Screen'),
      ),
    );
  }
}

