import 'package:flutter_test/flutter_test.dart';

import 'package:transporto/main.dart';

void main() {
  testWidgets('HomeView smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const TransPortoApp());

    expect(find.text('TransPorto'), findsOneWidget);
    expect(find.text('Partagez la route,'), findsOneWidget);
    expect(find.text('Destinations tendances cette semaine'), findsOneWidget);
  });
}
