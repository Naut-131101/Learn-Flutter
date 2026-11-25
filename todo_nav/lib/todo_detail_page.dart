import 'package:flutter/material.dart';
import 'todo.dart';
import 'add_todo_page.dart';

class TodoDetailPage extends StatelessWidget {
  final Todo todo;
  const TodoDetailPage({super.key, required this.todo});

  Future<void> _edit(BuildContext context) async {
    // Mở màn Add ở chế độ sửa, chờ Todo đã sửa trả về
    final updated = await Navigator.push<Todo>(
      context,
      MaterialPageRoute(builder: (_) => AddTodoPage(existing: todo)),
    );
    if (!context.mounted || updated == null) return;
    // Sửa xong: trả về List để cập nhật rồi rời màn Detail (vì dữ liệu đã cũ)
    Navigator.pop(context, TodoUpdated(updated));
  }

  Future<void> _delete(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Xoá todo?'),
        content: Text('Bạn chắc chắn muốn xoá "${todo.title}"?'),
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
    if (!context.mounted || ok != true) return;
    Navigator.pop(context, TodoDeleted(todo.id));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final created =
        '${todo.createdAt.day}/${todo.createdAt.month}/${todo.createdAt.year}';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết'),
        actions: [
          IconButton(
            onPressed: () => _edit(context),
            icon: const Icon(Icons.edit),
            tooltip: 'Sửa',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(todo.title, style: theme.textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text('Độ ưu tiên: ${todo.priority.label}'),
            const SizedBox(height: 4),
            Text('Tạo lúc: $created'),
            const SizedBox(height: 16),
            Text(todo.description.isEmpty
                ? '(Không có mô tả)'
                : todo.description),
            const Spacer(),
            FilledButton.tonalIcon(
              onPressed: () => _delete(context),
              icon: const Icon(Icons.delete),
              label: const Text('Xoá'),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
