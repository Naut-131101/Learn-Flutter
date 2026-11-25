import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CartItem {
  final int productId;
  final int quantity;

  CartItem({required this.productId, required this.quantity});

  Map<String, dynamic> toJson() =>
      {'productId': productId, 'quantity': quantity};

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        productId: json['productId'] as int,
        quantity: json['quantity'] as int,
      );

  CartItem copyWith({int? quantity}) =>
      CartItem(productId: productId, quantity: quantity ?? this.quantity);
}

class CartStorage {
  static const _key = 'cart';

  Future<List<CartItem>> getAll() async {
    final prefs = await SharedPreferences.getInstance();
    final str = prefs.getString(_key);
    if (str == null) return [];
    final List<dynamic> jsonList = jsonDecode(str) as List<dynamic>;
    return jsonList
        .map((j) => CartItem.fromJson(j as Map<String, dynamic>))
        .toList();
  }

  Future<void> save(List<CartItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        _key, jsonEncode(items.map((i) => i.toJson()).toList()));
  }

  // đã có productId => cộng dồn quantity, chưa có => thêm mới
  Future<void> add(int productId, int quantity) async {
    final items = await getAll();
    final i = items.indexWhere((c) => c.productId == productId);
    if (i >= 0) {
      items[i] = items[i].copyWith(quantity: items[i].quantity + quantity);
    } else {
      items.add(CartItem(productId: productId, quantity: quantity));
    }
    await save(items);
  }

  Future<void> remove(int productId) async {
    final items = await getAll();
    items.removeWhere((c) => c.productId == productId);
    await save(items);
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}