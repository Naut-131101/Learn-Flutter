import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/cart_provider.dart';
import 'pages/product_list_page.dart';

void main() async {
  // Bắt buộc khi await TRƯỚC runApp
  WidgetsFlutterBinding.ensureInitialized();

  final cart = CartProvider();
  await cart.load(); // nạp giỏ đã lưu trước khi vẽ UI

  runApp(
    // .value vì 'cart' đã tạo sẵn ở trên (KHÔNG dùng create:)
    ChangeNotifierProvider.value(
      value: cart,
      child: const MiniShopApp(),
    ),
  );
}

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