import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/car.dart';
import 'widgets/navigation_scaffold.dart';
import 'state/app_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive for Flutter (sets default storage path)
  await Hive.initFlutter();

  // Register Hive adapters
  Hive.registerAdapter(CarAdapter());

  // Open typed box for storing car data
  await Hive.openBox<Car>('carsBox');

  final appState = AppState();
  appState.loadFromHive();

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
