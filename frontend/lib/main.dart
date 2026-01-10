import 'package:flutter/material.dart';
import 'widgets/navigation_scaffold.dart';
import 'state/app_state.dart';

void main() {
  final appState = AppState();
  runApp(MyApp(appState: appState));
}

class MyApp extends StatelessWidget {
  final AppState appState;

  const MyApp({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Automotive Fault Detection',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: NavigationScaffold(appState: appState),
    );
  }
}
