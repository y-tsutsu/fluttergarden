import 'package:flutter/gestures.dart';
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

  testWidgets('ナビゲーションでToDo画面へ移動できる', (WidgetTester tester) async {
    await tester.pumpWidget(const FlutterGardenApp());

    await tester.tap(find.text('ToDo'));
    await tester.pumpAndSettle();

    expect(find.text('New ToDo'), findsOneWidget);
  });

  testWidgets('マウスドラッグでToDo画面へ移動できる', (WidgetTester tester) async {
    await tester.pumpWidget(const FlutterGardenApp());

    final gesture = await tester.startGesture(
      tester.getCenter(find.byType(PageView)),
      kind: PointerDeviceKind.mouse,
    );
    await gesture.moveBy(const Offset(-500, 0));
    await gesture.up();
    await tester.pumpAndSettle();

    expect(find.text('New ToDo'), findsOneWidget);
  });

  testWidgets('ToDoを追加して完了と削除を操作できる', (WidgetTester tester) async {
    await tester.pumpWidget(const FlutterGardenApp());
    await tester.tap(find.text('ToDo'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'Buy milk');
    await tester.tap(find.text('Add'));
    await tester.pump();

    expect(find.text('Buy milk'), findsOneWidget);
    expect(find.text('No ToDos'), findsNothing);

    await tester.tap(find.byType(Checkbox));
    await tester.pump();
    final todoText = tester.widget<Text>(find.text('Buy milk'));
    expect(todoText.style?.decoration, TextDecoration.lineThrough);

    await tester.tap(find.byTooltip('Delete'));
    await tester.pump();
    expect(find.text('Buy milk'), findsNothing);
    expect(find.text('No ToDos'), findsOneWidget);
  });

  testWidgets('画面を移動しても面積計算の状態を保持する', (WidgetTester tester) async {
    await tester.pumpWidget(const FlutterGardenApp());

    final sliders = find.byType(Slider);
    tester.widget<Slider>(sliders.at(0)).onChanged!(10);
    await tester.pump();
    tester.widget<Slider>(sliders.at(1)).onChanged!(20);
    await tester.pump();
    await tester.tap(find.text('Calculate'));
    await tester.pump();

    await tester.tap(find.text('ToDo'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Calculator'));
    await tester.pumpAndSettle();

    expect(find.text('200'), findsOneWidget);
  });
}
