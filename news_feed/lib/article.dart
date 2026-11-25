class Article {
  final int id;
  final String title;
  final String summary;
  final String imageUrl;
  final String author;
  final DateTime publishedAt;

  Article({
    required this.id,
    required this.title,
    required this.summary,
    required this.imageUrl,
    required this.author,
    required this.publishedAt,
  });
}

// Hàm (không phải biến global) => mỗi lần gọi tạo list MỚI,
// thời gian publishedAt luôn tính từ lúc gọi.
List<Article> buildSampleArticles() => List.generate(
  20,
  (i) => Article(
    id: i,
    title: 'Bài viết số ${i + 1}',
    summary: 'Đây là tóm tắt ngắn cho bài viết số ${i + 1}. '
        'Nội dung đầy đủ sẽ được tải từ API thật ở chương 8, '
        'tạm thời dùng đoạn văn mẫu này để dựng giao diện.',
    imageUrl: 'https://picsum.photos/300/200?random=$i',
    author: 'Tác giả ${i % 3 + 1}',
    publishedAt: DateTime.now().subtract(Duration(hours: i)),
  ),
);