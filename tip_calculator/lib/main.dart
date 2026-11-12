import 'package:flutter/material.dart';
import 'tip_calculator_screen.dart';

void main() {
  runApp(const TipCalculatorApp());
}

class TipCalculatorApp extends StatelessWidget {
  const TipCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tip Calculator',
      debugShowCheckedModeBanner: false, // ẩn banner DEBUG góc phải
      theme: ThemeData(
        // Tạo bảng màu đồng bộ từ 1 màu gốc – chuẩn Material 3
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      home: const TipCalculatorScreen(),
    );
  }
}