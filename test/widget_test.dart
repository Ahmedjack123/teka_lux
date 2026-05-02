import 'package:flutter_test/flutter_test.dart';

import 'package:teka_luxe/app.dart';

void main() {
  testWidgets('app starts', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Teka Luxe'), findsOneWidget);
  });
}
