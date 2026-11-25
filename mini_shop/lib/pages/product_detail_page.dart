import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../main.dart';
import '../models/product.dart';

class ProductDetailPage extends StatefulWidget {
  final int productId;
  const ProductDetailPage({super.key, required this.productId});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  late Future<Product> _future;

  @override
  void initState() {
    super.initState();
    // Tạo Future MỘT LẦN trong initState – không tạo trong build!
    _future = productRepo.getById(widget.productId);
  }

  void _retry() {
    setState(() => _future = productRepo.getById(widget.productId));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Chi tiết sản phẩm')),
      body: FutureBuilder<Product>(
        future: _future,
        builder: (context, snapshot) {
          // 1. Đang tải
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // 2. Lỗi
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.wifi_off, size: 48, color: Colors.grey),
                  const SizedBox(height: 8),
                  Text('${snapshot.error}'),
                  const SizedBox(height: 12),
                  FilledButton(onPressed: _retry, child: const Text('Thử lại')),
                ],
              ),
            );
          }
          // 3. Có data
          final p = snapshot.data!;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                (p.imageUrl == null || p.imageUrl!.isEmpty)
                    ? Container(
                        width: double.infinity,
                        height: 300,
                        color: Colors.grey.shade300,
                        child: const Icon(Icons.image_not_supported, size: 48),
                      )
                    : CachedNetworkImage(
                        imageUrl: p.imageUrl!,
                        width: double.infinity,
                        height: 300,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => Container(
                          width: double.infinity,
                          height: 300,
                          color: Colors.grey.shade200,
                        ),
                        errorWidget: (_, __, ___) => Container(
                          width: double.infinity,
                          height: 300,
                          color: Colors.grey.shade300,
                          child: const Icon(
                            Icons.image_not_supported,
                            size: 48,
                          ),
                        ),
                      ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(p.name, style: theme.textTheme.headlineSmall),
                      const SizedBox(height: 8),
                      Text(
                        '${p.price.toStringAsFixed(0)}đ',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Chip(label: Text(p.category)),
                      const SizedBox(height: 16),
                      Text(p.description ?? '(Chưa có mô tả)'),
                      const SizedBox(height: 24),
                      FilledButton.icon(
                        // Chương Provider mới làm giỏ hàng – tạm báo SnackBar
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Giỏ hàng sẽ làm ở chương sau!'),
                            ),
                          );
                        },
                        icon: const Icon(Icons.add_shopping_cart),
                        label: const Text('Thêm vào giỏ'),
                        style: FilledButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
