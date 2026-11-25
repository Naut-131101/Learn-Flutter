import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'news_feed_page.dart';

void main() {
  // Đăng ký locale 'vi' TRƯỚC runApp - nếu quên, timeago sẽ in tiếng Anh
  timeago.setLocaleMessages('vi', timeago.ViMessages());
  runApp(const NewsApp());
}

class NewsApp extends StatelessWidget {
  const NewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      home: const NewsFeedPage(),
    );
  }
}