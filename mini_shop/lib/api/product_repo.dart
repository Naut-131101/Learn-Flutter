import '../models/product.dart';
import 'api_client.dart';

class ProductRepo {
  final ApiClient _api;
  ProductRepo(this._api);

  // Danh sách dữ liệu giả lập cục bộ
  final List<Product> _mockProducts = [
    Product(
      id: 1,
      name: 'Áo thun Cotton Basic',
      price: 150000,
      imageUrl: 'https://picsum.photos/seed/p1/400/400',
      description: 'Chất liệu cotton 100% thoáng mát.',
      category: 'Áo',
    ),
    Product(
      id: 2,
      name: 'Quần Jeans Slimfit',
      price: 420000,
      imageUrl: 'https://picsum.photos/seed/p2/400/400',
      description: 'Form dáng hiện đại, bền màu.',
      category: 'Quần',
    ),
    Product(
      id: 3,
      name: 'Túi Tote Vải Canvas (Test thiếu ảnh)',
      price: 89000,
      imageUrl: null,
      description: null,
      category: 'Phụ kiện',
    ),
  ];

  Future<List<Product>> getAll({String? category}) async {
    await Future.delayed(const Duration(seconds: 1)); // giả lập loading
    if (category != null) {
      return _mockProducts.where((p) => p.category == category).toList();
    }
    return _mockProducts;
  }

  Future<Product> getById(int id) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return _mockProducts.firstWhere((p) => p.id == id);
  }
}