import 'package:flutter_test/flutter_test.dart';

import 'package:teka_luxe/main.dart';

void main() {
  testWidgets('app starts on login page', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Teka Luxe'), findsOneWidget);
    expect(find.text('Sign in'), findsOneWidget);
  });
}
