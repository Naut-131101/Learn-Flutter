
import 'package:flutter_test/flutter_test.dart';
import 'package:register_form/main.dart';

void main() {
  testWidgets('Register app builds successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const RegisterApp());

    expect(find.byType(RegisterApp), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

