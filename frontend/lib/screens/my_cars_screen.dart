import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../features/my_car/my_car_page.dart';

class MyCarsScreen extends StatelessWidget {
  final AppState appState;

  const MyCarsScreen({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    return MyCarPage(appState: appState);
  }
}
