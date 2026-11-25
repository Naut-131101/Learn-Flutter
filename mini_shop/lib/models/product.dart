class Product {
  final int id;
  final String name;
  final double price;
  final String? imageUrl;    // nullable: server có thể không có ảnh
  final String? description; // nullable: server có thể không có mô tả
  final String category;

  Product({
    required this.id,
    required this.name,
    required this.price,
    this.imageUrl,
    this.description,
    required this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json['id'] as int,
    name: json['name'] as String,
    // num.toDouble(): chấp nhận cả 100000 (int) lẫn 99000.5 (double)
    price: (json['price'] as num).toDouble(),
    imageUrl: json['imageUrl'] as String?,
    description: json['description'] as String?,
    category: json['category'] as String,
  );
}