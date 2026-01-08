import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/diagnose_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/insights_screen.dart';
import '../state/app_state.dart';
import '../utils/app_constants.dart';

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
      DiagnoseScreen(appState: widget.appState),
      DashboardScreen(appState: widget.appState),
      InsightsScreen(appState: widget.appState),
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: AppConstants.homeLabel,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: AppConstants.diagnoseLabel,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: AppConstants.dashboardLabel,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insights),
            label: AppConstants.insightsLabel,
          ),
        ],
      ),
    );
  }
}

