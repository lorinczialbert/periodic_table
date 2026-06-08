import 'package:flutter_test/flutter_test.dart';
import 'package:chem_table/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ChemTableApp());
    expect(find.byType(ChemTableApp), findsOneWidget);
  });
}
