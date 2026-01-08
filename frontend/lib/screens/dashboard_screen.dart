import 'package:flutter/material.dart';
import '../state/app_state.dart';

class DashboardScreen extends StatelessWidget {
  final AppState appState;

  const DashboardScreen({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: const Center(
        child: Text('Dashboard Screen'),
      ),
    );
  }
}

