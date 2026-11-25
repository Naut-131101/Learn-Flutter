import 'package:flutter/foundation.dart';

import '../models/cart_item.dart';
import '../models/product.dart';
import '../storage/cart_storage.dart';

class CartProvider extends ChangeNotifier {
  final CartStorage _storage = CartStorage();
  List<CartItem> _items = [];

  // GETTERS - UI đọc qua đây
  List<CartItem> get items => List.unmodifiable(_items);
  int get itemCount => _items.fold(0, (sum, i) => sum + i.quantity);
  double get total =>
      _items.fold(0.0, (sum, i) => sum + i.price * i.quantity);

  // Gọi 1 lần lúc khởi động app (xem main.dart)
  Future<void> load() async {
    _items = await _storage.getAll();
    notifyListeners();
  }

  Future<void> addItem(Product p, {int quantity = 1}) async {
    final i = _items.indexWhere((c) => c.productId == p.id);
    if (i >= 0) {
      _items[i] = _items[i].copyWith(quantity: _items[i].quantity + quantity);
    } else {
      _items.add(CartItem(
        productId: p.id,
        name: p.name,
        price: p.price,
        imageUrl: p.imageUrl,
        quantity: quantity,
      ));
    }
    notifyListeners(); // UI rebuild NGAY
    await _persist();  // rồi mới lưu xuống đĩa
  }

  Future<void> updateQuantity(int productId, int quantity) async {
    final i = _items.indexWhere((c) => c.productId == productId);
    if (i < 0) return;
    if (quantity <= 0) {
      _items.removeAt(i); // giảm về 0 => xoá luôn
    } else {
      _items[i] = _items[i].copyWith(quantity: quantity);
    }
    notifyListeners();
    await _persist();
  }

  Future<void> removeItem(int productId) async {
    _items.removeWhere((c) => c.productId == productId);
    notifyListeners();
    await _persist();
  }

  Future<void> clear() async {
    _items = [];
    notifyListeners();
    await _persist();
  }

  Future<void> _persist() => _storage.save(_items);
}