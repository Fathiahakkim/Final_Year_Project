import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/my_cars_screen.dart';
import '../screens/diagnose_screen.dart';
import '../screens/obd_data_screen.dart';
import '../screens/account_screen.dart';
import '../state/app_state.dart';
import 'app_bottom_nav.dart';

class NavigationScaffold extends StatefulWidget {
  final AppState appState;

  const NavigationScaffold({super.key, required this.appState});

  @override
  State<NavigationScaffold> createState() => _NavigationScaffoldState();
}

class _NavigationScaffoldState extends State<NavigationScaffold> {
  int _currentIndex = 0;

  final List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();
    _screens.addAll([
      HomeScreen(appState: widget.appState),
      MyCarsScreen(appState: widget.appState),
      DiagnoseScreen(appState: widget.appState),
      OBDDataScreen(appState: widget.appState),
      AccountScreen(appState: widget.appState),
    ]);
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: AppBottomNav(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}

