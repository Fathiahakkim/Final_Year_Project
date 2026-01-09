import 'package:flutter/material.dart';
import '../state/app_state.dart';

class AccountScreen extends StatelessWidget {
  final AppState appState;

  const AccountScreen({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
      ),
      body: const Center(
        child: Text('Account Screen'),
      ),
    );
  }
}
