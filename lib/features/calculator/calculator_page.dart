import 'package:flutter/material.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  static const int _maxDimension = 100;
  static const int _maxArea = _maxDimension * _maxDimension;

  int _height = 0;
  int _width = 0;
  int _area = 0;
  bool _continuousCalculation = false;

  void _setHeight(double value) {
    setState(() {
      _height = value.round();
      _updateAreaIfNeeded();
    });
  }

  void _setWidth(double value) {
    setState(() {
      _width = value.round();
      _updateAreaIfNeeded();
    });
  }

  void _setContinuousCalculation(bool value) {
    setState(() {
      _continuousCalculation = value;
      _updateAreaIfNeeded();
    });
  }

  void _calculateArea() {
    setState(() {
      _area = _height * _width;
    });
  }

  void _updateAreaIfNeeded() {
    if (_continuousCalculation) {
      _area = _height * _width;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('fluttergarden 🌱')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _DimensionSlider(
                        label: 'Height',
                        value: _height,
                        max: _maxDimension,
                        onChanged: _setHeight,
                      ),
                    ),
                    const SizedBox(width: 32),
                    Expanded(
                      child: _DimensionSlider(
                        label: 'Width',
                        value: _width,
                        max: _maxDimension,
                        onChanged: _setWidth,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Continuous calculation'),
                  value: _continuousCalculation,
                  onChanged: _setContinuousCalculation,
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: FilledButton(
                    onPressed: _calculateArea,
                    child: const Text('Calculate'),
                  ),
                ),
                const SizedBox(height: 32),
                Text('Area', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Text(
                  '$_area',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Slider(
                  value: _area.toDouble(),
                  max: _maxArea.toDouble(),
                  onChanged: null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DimensionSlider extends StatelessWidget {
  const _DimensionSlider({
    required this.label,
    required this.value,
    required this.max,
    required this.onChanged,
  });

  final String label;
  final int value;
  final int max;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Text('$value'),
        Slider(
          value: value.toDouble(),
          max: max.toDouble(),
          divisions: max,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
