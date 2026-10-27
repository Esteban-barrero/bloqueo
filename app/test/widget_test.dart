import 'package:flutter_test/flutter_test.dart';

import 'package:bloqueo/main.dart';

void main() {
  testWidgets('Pantalla de bloqueo muestra el mensaje', (WidgetTester tester) async {
    await tester.pumpWidget(const BloqueoApp());

    // Espera la animación de entrada de la tarjeta/pantalla.
    await tester.pump(const Duration(milliseconds: 1500));
    await tester.pump(const Duration(milliseconds: 300));

    // Verifica que la pantalla de bloqueo se muestre.
    expect(find.text('Está bloqueado'), findsOneWidget);
    expect(find.text('Instagram'), findsOneWidget);
    expect(find.text('Oye, no pierdas el tiempo...'), findsOneWidget);
    expect(find.text('Cancelar bloqueo'), findsOneWidget);
  });
}
