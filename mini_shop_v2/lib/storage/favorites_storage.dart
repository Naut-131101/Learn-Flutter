import 'package:shared_preferences/shared_preferences.dart';

// Chỉ lưu danh sách ID yêu thích – nhẹ, đủ dùng (chi tiết sản phẩm có sẵn ở data).
class FavoritesStorage {
  static const _key = 'favorites';

  Future<Set<int>> getAll() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? []; // chưa có => list rỗng
    return list.map(int.parse).toSet(); // Set: không trùng, check cực nhanh
  }

  Future<void> toggle(int productId) async {
    final prefs = await SharedPreferences.getInstance();
    final favs = await getAll();
    if (favs.contains(productId)) {
      favs.remove(productId); // đang thích => bỏ
    } else {
      favs.add(productId);    // chưa thích => thêm
    }
    await prefs.setStringList(
      _key,
      favs.map((id) => id.toString()).toList(), // Set<int> -> List<String>
    );
  }

  Future<bool> isFavorite(int productId) async {
    final favs = await getAll();
    return favs.contains(productId);
  }
}