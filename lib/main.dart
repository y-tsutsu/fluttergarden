import 'package:flutter/material.dart';
import 'package:fluttergarden/features/calculator/calculator_page.dart';

void main() {
  runApp(const FlutterGardenApp());
}

class FlutterGardenApp extends StatelessWidget {
  const FlutterGardenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'fluttergarden',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      home: const CalculatorPage(),
    );
  }
}
