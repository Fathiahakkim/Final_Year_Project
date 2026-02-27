import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../features/my_car/my_car_page.dart';

class MyCarsScreen extends StatelessWidget {
  final AppState appState;
  final VoidCallback? onNavigateHome;

  const MyCarsScreen({super.key, required this.appState, this.onNavigateHome});

  @override
  Widget build(BuildContext context) {
    return MyCarPage(appState: appState, onNavigateHome: onNavigateHome);
  }
}
