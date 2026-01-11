import 'package:flutter/material.dart';
import 'theme/my_car_theme.dart';
import 'widgets/my_car_app_bar.dart';
import 'widgets/my_car_background.dart';
import 'widgets/my_car_header.dart';
import 'widgets/add_car_button.dart';
import 'widgets/my_car_white_card.dart';
import '../diagnose/utils/diagnose_spacing.dart';
import '../../state/app_state.dart';
import '../../models/car_model.dart';

class MyCarPage extends StatefulWidget {
  final AppState appState;

  const MyCarPage({super.key, required this.appState});

  @override
  State<MyCarPage> createState() => _MyCarPageState();
}

class _MyCarPageState extends State<MyCarPage> {
  bool _isCardExpanded = false;

  void _handleAddCar() {
    setState(() {
      _isCardExpanded = !_isCardExpanded;
    });
  }

  void _handleSaveCar(String make, String model, int year, String licensePlate) {
    // Save car data to app state
    final newCar = CarModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      make: make,
      model: model,
      year: year,
      licensePlate: licensePlate,
      imageUrl: '',
      healthStatus: 'HEALTHY',
    );
    
    widget.appState.addCar(newCar);
    
    setState(() {
      _isCardExpanded = false;
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Car saved successfully')));
  }

  void _handleCancelAddCar() {
    setState(() {
      _isCardExpanded = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;
    final keyboardHeight = mediaQuery.viewInsets.bottom;
    final isSmallScreen = screenWidth < 360;

    // Calculate card height using same method as diagnose page
    final cardHeight = DiagnoseSpacing.calculateCardHeight(screenHeight);

    // Responsive spacing
    final topPadding =
        isSmallScreen ? MyCarTheme.topPadding * 0.85 : MyCarTheme.topPadding;
    final sectionSpacing =
        isSmallScreen
            ? MyCarTheme.sectionSpacing * 0.75
            : MyCarTheme.sectionSpacing;

    return Scaffold(
      appBar: MyCarAppBar(
        onAddCar: _handleAddCar,
        isAddCarMode: _isCardExpanded,
      ),
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: true,
      body: MyCarBackground(
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (!_isCardExpanded)
              // Initial state: Scrollable content with header
              SafeArea(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                    top: topPadding,
                    bottom: cardHeight + 24.0,
                  ),
                  child: Column(
                    children: [
                      // Header section with car icon and description
                      const MyCarHeader(),
                      SizedBox(height: sectionSpacing),
                      // ADD CAR button
                      AddCarButton(onPressed: _handleAddCar),
                    ],
                  ),
                ),
              )
            else
              // Expanded state: Show car icon and "Add Car" title
              SafeArea(
                child: Column(
                  children: [
                    SizedBox(height: topPadding),
                    // Car icon - circular white outline
                    Container(
                      width: MyCarTheme.carIconSize,
                      height: MyCarTheme.carIconSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.25),
                          width: 2.5,
                        ),
                      ),
                      child: Icon(
                        Icons.directions_car_outlined,
                        size: MyCarTheme.carIconSize * 0.55,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // "Add Car" title
                    const Text(
                      'Add Car',
                      style: TextStyle(
                        color: MyCarTheme.textPrimary,
                        fontSize: MyCarTheme.titleFontSize,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            // White card overlay at bottom
            MyCarWhiteCard(
              cardHeight: cardHeight,
              keyboardHeight: keyboardHeight,
              isExpanded: _isCardExpanded,
              appState: widget.appState,
              onSave: _handleSaveCar,
              onCancel: _handleCancelAddCar,
            ),
          ],
        ),
      ),
    );
  }
}
