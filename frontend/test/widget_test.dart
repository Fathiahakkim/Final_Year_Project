import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/main.dart';
import 'package:frontend/state/app_state.dart';

void main() {
  testWidgets('App initializes and shows navigation', (WidgetTester tester) async {
    final appState = AppState();
    
    await tester.pumpWidget(MyApp(appState: appState));

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Diagnose'), findsOneWidget);
    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.text('Insights'), findsOneWidget);
  });
}
