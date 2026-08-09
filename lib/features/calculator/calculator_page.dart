import 'package:flutter/material.dart';
import 'package:fluttergarden/features/calculator/calculator_view_model.dart';
import 'package:provider/provider.dart';

class CalculatorPage extends StatelessWidget {
  const CalculatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CalculatorViewModel>();

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
                        value: viewModel.height,
                        max: CalculatorViewModel.maxDimension,
                        onChanged: (value) {
                          viewModel.setHeight(value.round());
                        },
                      ),
                    ),
                    const SizedBox(width: 32),
                    Expanded(
                      child: _DimensionSlider(
                        label: 'Width',
                        value: viewModel.width,
                        max: CalculatorViewModel.maxDimension,
                        onChanged: (value) {
                          viewModel.setWidth(value.round());
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Continuous calculation'),
                  value: viewModel.continuousCalculation,
                  onChanged: viewModel.setContinuousCalculation,
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: FilledButton(
                    onPressed: viewModel.calculateArea,
                    child: const Text('Calculate'),
                  ),
                ),
                const SizedBox(height: 32),
                Text('Area', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Text(
                  '${viewModel.area}',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Slider(
                  value: viewModel.area.toDouble(),
                  max: CalculatorViewModel.maxArea.toDouble(),
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
