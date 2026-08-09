import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fluttergarden/main.dart';

void main() {
  testWidgets('面積を計算できる', (WidgetTester tester) async {
    await tester.pumpWidget(const FlutterGardenApp());

    expect(find.text('Height'), findsOneWidget);
    expect(find.text('Width'), findsOneWidget);
    expect(find.text('Area'), findsOneWidget);

    final sliders = find.byType(Slider);
    final heightSlider = tester.widget<Slider>(sliders.at(0));
    final widthSlider = tester.widget<Slider>(sliders.at(1));

    heightSlider.onChanged!(10);
    await tester.pump();
    widthSlider.onChanged!(20);
    await tester.pump();

    expect(find.text('200'), findsNothing);

    await tester.tap(find.text('Calculate'));
    await tester.pump();

    expect(find.text('200'), findsOneWidget);
  });

  testWidgets('連続計算で入力時に面積を更新できる', (WidgetTester tester) async {
    await tester.pumpWidget(const FlutterGardenApp());

    await tester.tap(find.byType(Switch));
    await tester.pump();

    final sliders = find.byType(Slider);
    final heightSlider = tester.widget<Slider>(sliders.at(0));
    final widthSlider = tester.widget<Slider>(sliders.at(1));

    heightSlider.onChanged!(30);
    await tester.pump();
    widthSlider.onChanged!(20);
    await tester.pump();

    expect(find.text('600'), findsOneWidget);
  });
}
