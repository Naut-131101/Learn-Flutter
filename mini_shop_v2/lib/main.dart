import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pages/onboarding_page.dart';
import 'pages/home_page.dart';

void main() => runApp(const MiniShopApp());

class MiniShopApp extends StatelessWidget {
  const MiniShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MiniShop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      home: const AppLauncher(), // điểm vào: quyết định Onboarding hay Home
    );
  }
}

// Widget gốc: đọc cờ onboarding_seen rồi chọn màn hình
class AppLauncher extends StatefulWidget {
  const AppLauncher({super.key});

  @override
  State<AppLauncher> createState() => _AppLauncherState();
}

class _AppLauncherState extends State<AppLauncher> {
  bool? _showOnboarding; // null = đang đọc prefs

  @override
  void initState() {
    super.initState();
    _check();
  }

  Future<void> _check() async {
    final prefs = await SharedPreferences.getInstance();
    final seen = prefs.getBool('onboarding_seen') ?? false; // chưa có => false
    if (!mounted) return;
    setState(() => _showOnboarding = !seen);
  }

  @override
  Widget build(BuildContext context) {
    if (_showOnboarding == null) {
      // đang đọc prefs => loading, tránh chớp nhầm màn
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return _showOnboarding! ? const OnboardingPage() : const HomePage();
  }
}