class Product {
  final int id;
  final String name;
  final double price; // hoặc int tùy bạn khai báo
  final String imageUrl;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
  });
}