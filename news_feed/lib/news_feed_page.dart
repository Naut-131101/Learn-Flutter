import 'dart:math';

import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'article.dart';
import 'article_detail_page.dart';

class NewsFeedPage extends StatefulWidget {
  const NewsFeedPage({super.key});

  @override
  State<NewsFeedPage> createState() => _NewsFeedPageState();
}

class _NewsFeedPageState extends State<NewsFeedPage> {
  final List<Article> _articles = buildSampleArticles();
  final ScrollController _scrollController = ScrollController();
  bool _showScrollToTop = false;

  @override
  void initState() {
    super.initState();
    // Lắng nghe vị trí cuộn để ẩn/hiện nút FAB
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final shouldShow = _scrollController.offset > 200;
    if (shouldShow != _showScrollToTop) {
      setState(() => _showScrollToTop = shouldShow);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() => _articles.shuffle(Random()));
  }

  Future<bool> _confirmDelete(Article article) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Xoá bài viết?'),
        content: Text('Bạn chắc chắn muốn xoá "${article.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Huỷ'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Xoá'),
          ),
        ],
      ),
    );
    return ok ?? false;
  }

  // Xoá bài viết và hiện SnackBar kèm nút Hoàn tác
  void _handleDelete(Article article) {
    final deletedIndex = _articles.indexWhere((a) => a.id == article.id);
    if (deletedIndex == -1) return;

    setState(() {
      _articles.removeAt(deletedIndex);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã xoá "${article.title}"'),
        action: SnackBarAction(
          label: 'Hoàn tác',
          onPressed: () {
            setState(() {
              final insertIndex = deletedIndex.clamp(0, _articles.length);
              _articles.insert(insertIndex, article);
            });
          },
        ),
      ),
    );
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
    );
  }

  void _openDetail(Article article) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ArticleDetailPage(article: article)),
    );
  }

  void _openSearch() {
    showSearch(
      context: context,
      delegate: _ArticleSearchDelegate(
        articles: _articles,
        onSelectArticle: _openDetail,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News'),
        actions: [
          IconButton(
            onPressed: _openSearch,
            icon: const Icon(Icons.search),
            tooltip: 'Tìm kiếm',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: ListView.builder(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: _articles.length,
          itemBuilder: (context, i) {
            final article = _articles[i];
            return Dismissible(
              key: ValueKey(article.id),
              direction: DismissDirection.endToStart,
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 24),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              confirmDismiss: (_) => _confirmDelete(article),
              onDismissed: (_) => _handleDelete(article),
              child: _ArticleCard(
                article: article,
                onTap: () => _openDetail(article),
              ),
            );
          },
        ),
      ),
      // Ẩn/hiện mượt mà bằng AnimatedOpacity, IgnorePointer tránh bấm nhầm khi ẩn
      floatingActionButton: AnimatedOpacity(
        opacity: _showScrollToTop ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 250),
        child: IgnorePointer(
          ignoring: !_showScrollToTop,
          child: FloatingActionButton.extended(
            onPressed: _scrollToTop,
            icon: const Icon(Icons.arrow_upward),
            label: const Text('Top'),
          ),
        ),
      ),
    );
  }
}

// SearchDelegate lọc bài viết theo tiêu đề
class _ArticleSearchDelegate extends SearchDelegate<void> {
  final List<Article> articles;
  final ValueChanged<Article> onSelectArticle;

  _ArticleSearchDelegate({
    required this.articles,
    required this.onSelectArticle,
  });

  @override
  String get searchFieldLabel => 'Tìm theo tiêu đề bài viết...';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () => query = '',
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) => _buildFilteredList();

  @override
  Widget buildSuggestions(BuildContext context) => _buildFilteredList();

  Widget _buildFilteredList() {
    final keyword = query.trim().toLowerCase();
    final results = keyword.isEmpty
        ? articles
        : articles
            .where((a) => a.title.toLowerCase().contains(keyword))
            .toList();

    if (results.isEmpty) {
      return const Center(
        child: Text('Không tìm thấy bài viết nào phù hợp.'),
      );
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final article = results[index];
        return _ArticleCard(
          article: article,
          onTap: () {
            close(context, null);
            onSelectArticle(article);
          },
        );
      },
    );
  }
}

// Item Card: ảnh trái 80x80 có loadingBuilder + title + author + thời gian
class _ArticleCard extends StatelessWidget {
  final Article article;
  final VoidCallback onTap;
  const _ArticleCard({required this.article, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  article.imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey.shade200,
                      alignment: Alignment.center,
                      child: const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  },
                  errorBuilder: (_, __, ___) => Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.broken_image),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(article.author, style: theme.textTheme.bodySmall),
                    Text(
                      timeago.format(article.publishedAt, locale: 'vi'),
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: theme.colorScheme.primary),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}