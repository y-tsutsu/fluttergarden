import 'package:flutter/material.dart';
import 'package:fluttergarden/features/calculator/calculator_view_model.dart';
import 'package:fluttergarden/features/home/home_page.dart';
import 'package:fluttergarden/features/todo/todo_view_model.dart';
import 'package:provider/provider.dart';

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
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => CalculatorViewModel()),
          ChangeNotifierProvider(create: (context) => TodoViewModel()),
        ],
        child: const HomePage(),
      ),
    );
  }
}
