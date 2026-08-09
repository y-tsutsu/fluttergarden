import 'package:flutter/material.dart';

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
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('fluttergarden 🌱')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            debugPrint('Button clicked!');
          },
          child: const Text('Click Me'),
        ),
      ),
    );
  }
}
