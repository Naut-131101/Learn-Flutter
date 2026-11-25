import 'package:flutter/material.dart';

import 'api/api_client.dart';
import 'api/product_repo.dart';
import 'pages/product_list_page.dart';

// Khởi tạo 1 lần, dùng chung toàn app (chương State Management sẽ thay bằng Provider)
final apiClient = ApiClient();
final productRepo = ProductRepo(apiClient);

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
      home: const ProductListPage(),
    );
  }
}