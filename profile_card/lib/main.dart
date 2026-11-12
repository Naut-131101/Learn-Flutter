import 'package:flutter/material.dart';
import 'pages/profile_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile Card',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // 1 màu hạt giống => Flutter tự sinh cả bảng màu Material 3
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
      ),
      home: const ProfilePage(),
    );
  }
}