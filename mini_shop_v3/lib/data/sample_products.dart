import '../models/product.dart';

// Data mẫu – lab này tập trung vào lưu local nên không cần backend.
// Ảnh lấy từ picsum.photos (cần quyền INTERNET, đã khai báo ở Bước 0).
const sampleProducts = <Product>[
  Product(id: 1, name: 'Áo thun trắng',   price: 150000, imageUrl: 'https://picsum.photos/id/1011/400'),
  Product(id: 2, name: 'Quần jeans xanh', price: 350000, imageUrl: 'https://picsum.photos/id/1012/400'),
  Product(id: 3, name: 'Giày sneaker',    price: 800000, imageUrl: 'https://picsum.photos/id/1013/400'),
  Product(id: 4, name: 'Mũ lưỡi trai',    price: 120000, imageUrl: 'https://picsum.photos/id/1015/400'),
  Product(id: 5, name: 'Balo du lịch',    price: 450000, imageUrl: 'https://picsum.photos/id/1016/400'),
  Product(id: 6, name: 'Kính râm',        price: 250000, imageUrl: 'https://picsum.photos/id/1025/400'),
];