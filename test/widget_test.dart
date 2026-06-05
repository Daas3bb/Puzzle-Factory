import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/main.dart';

void main() {
  testWidgets('PuzzleApp builds without error', (WidgetTester tester) async {
    await tester.pumpWidget(const PuzzleApp());
    expect(find.text('Puzzle Album'), findsOneWidget);
  });
}
