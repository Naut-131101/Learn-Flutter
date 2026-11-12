
import 'package:flutter_test/flutter_test.dart';
import 'package:tip_calculator/main.dart';

void main() {
  testWidgets('Tip Calculator app builds', (WidgetTester tester) async {
    await tester.pumpWidget(const TipCalculatorApp());

    expect(find.byType(TipCalculatorApp), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
