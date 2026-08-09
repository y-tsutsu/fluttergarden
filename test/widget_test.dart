import 'package:flutter_test/flutter_test.dart';

import 'package:fluttergarden/main.dart';

void main() {
  testWidgets('最小画面を表示できる', (WidgetTester tester) async {
    await tester.pumpWidget(const FlutterGardenApp());

    expect(find.text('fluttergarden 🌱'), findsOneWidget);
    expect(find.text('Click Me'), findsOneWidget);

    await tester.tap(find.text('Click Me'));
  });
}
