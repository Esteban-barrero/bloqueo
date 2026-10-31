import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:bloqueo/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  testWidgets('App inicia y muestra la pantalla principal', (WidgetTester tester) async {
    await tester.pumpWidget(const BloqueoApp());
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Bloqueo Por Momento Jejeejj'), findsOneWidget);
    expect(find.text('Aun no tienes bloqueos'), findsOneWidget);
  });
}
