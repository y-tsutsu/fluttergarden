import 'package:flutter/foundation.dart';

class CalculatorViewModel extends ChangeNotifier {
  static const int maxDimension = 100;
  static const int maxArea = maxDimension * maxDimension;

  int _height = 0;
  int _width = 0;
  int _area = 0;
  bool _continuousCalculation = false;

  int get height => _height;
  int get width => _width;
  int get area => _area;
  bool get continuousCalculation => _continuousCalculation;

  void setHeight(int value) {
    if (_height == value) {
      return;
    }

    _height = value;
    _updateAreaIfNeeded();
    notifyListeners();
  }

  void setWidth(int value) {
    if (_width == value) {
      return;
    }

    _width = value;
    _updateAreaIfNeeded();
    notifyListeners();
  }

  void setContinuousCalculation(bool value) {
    if (_continuousCalculation == value) {
      return;
    }

    _continuousCalculation = value;
    _updateAreaIfNeeded();
    notifyListeners();
  }

  void calculateArea() {
    final newArea = _height * _width;
    if (_area == newArea) {
      return;
    }

    _area = newArea;
    notifyListeners();
  }

  void _updateAreaIfNeeded() {
    if (_continuousCalculation) {
      _area = _height * _width;
    }
  }
}
