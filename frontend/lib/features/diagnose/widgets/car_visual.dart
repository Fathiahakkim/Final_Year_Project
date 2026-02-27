import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import '../../../state/app_state.dart';
import '../../../utils/car_glb_map.dart';

class CarVisual extends StatelessWidget {
  final AppState appState;

  const CarVisual({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListenableBuilder(
        listenable: appState,
        builder: (context, child) {
          final selectedCar = appState.primaryCar;
          final glbPath = resolveCarGlb(selectedCar?.make ?? 'BMW');

          return SizedBox(
            width: double.infinity,
            height: 160,
            child: ModelViewer(
              src: glbPath,
              alt: selectedCar != null
                  ? '${selectedCar.make} ${selectedCar.model}'
                  : 'Car Model',
              autoRotate: true,
              cameraControls: true,
              disableZoom: false,
              cameraOrbit: '0deg 75deg 105%',
              fieldOfView: '30deg',
              backgroundColor: Colors.transparent,
            ),
          );
        },
      ),
    );
  }
}
