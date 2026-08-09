import 'package:flutter_test/flutter_test.dart';
import 'package:fluttergarden/features/calculator/calculator_view_model.dart';

void main() {
  late CalculatorViewModel viewModel;

  setUp(() {
    viewModel = CalculatorViewModel();
  });

  tearDown(() {
    viewModel.dispose();
  });

  test('初期状態が正しい', () {
    expect(viewModel.height, 0);
    expect(viewModel.width, 0);
    expect(viewModel.area, 0);
    expect(viewModel.continuousCalculation, isFalse);
  });

  test('高さと幅から面積を計算できる', () {
    viewModel.setHeight(10);
    viewModel.setWidth(20);

    expect(viewModel.area, 0);

    viewModel.calculateArea();

    expect(viewModel.area, 200);
  });

  test('連続計算で入力時に面積を更新できる', () {
    viewModel.setContinuousCalculation(true);
    viewModel.setHeight(30);
    viewModel.setWidth(20);

    expect(viewModel.area, 600);
  });

  test('状態が変更されたときだけリスナーへ通知する', () {
    var notificationCount = 0;
    viewModel.addListener(() {
      notificationCount++;
    });

    viewModel.setHeight(10);
    expect(notificationCount, 1);

    viewModel.setHeight(10);
    expect(notificationCount, 1);

    viewModel.setWidth(20);
    expect(notificationCount, 2);

    viewModel.calculateArea();
    expect(notificationCount, 3);

    viewModel.calculateArea();
    expect(notificationCount, 3);
  });
}
