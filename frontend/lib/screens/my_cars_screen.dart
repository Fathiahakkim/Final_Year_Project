import 'package:flutter/material.dart';
import '../state/app_state.dart';

class MyCarsScreen extends StatelessWidget {
  final AppState appState;

  const MyCarsScreen({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cars'),
      ),
      body: const Center(
        child: Text('My Cars Screen'),
      ),
    );
  }
}
