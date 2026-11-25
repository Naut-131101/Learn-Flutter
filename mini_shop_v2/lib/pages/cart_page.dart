import 'package:flutter/material.dart';

import '../data/sample_products.dart';
import '../models/product.dart';
import '../storage/cart_storage.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final _cart = CartStorage();
  late Future<List<CartItem>> _future;

  @override
  void initState() {
    super.initState();
    _future = _cart.getAll(); // đọc giỏ MỘT LẦN khi mở màn
  }

  void _reload() => setState(() => _future = _cart.getAll());

  // ghép productId trong giỏ với data sản phẩm để lấy tên/giá/ảnh
  Product _productOf(int id) => sampleProducts.firstWhere((p) => p.id == id);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Giỏ hàng')),
      body: FutureBuilder<List<CartItem>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final items = snapshot.data ?? [];
          if (items.isEmpty) {
            return const Center(child: Text('Giỏ hàng trống'));
          }
          return ListView.separated(
            itemCount: items.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, i) {
              final item = items[i];
              final p = _productOf(item.productId);
              return ListTile(
                leading: SizedBox(
                  width: 56, height: 56,
                  child: Image.network(p.imageUrl, fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                            color: Colors.grey.shade300,
                            child: const Icon(Icons.image_not_supported),
                          )),
                ),
                title: Text(p.name),
                subtitle:
                    Text('${p.price.toStringAsFixed(0)}đ x ${item.quantity}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () async {
                    await _cart.remove(item.productId);
                    _reload();
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}