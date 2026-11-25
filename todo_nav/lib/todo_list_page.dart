import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'todo.dart';
import 'add_todo_page.dart';
import 'todo_detail_page.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  static const _storageKey = 'todos';

  final List<Todo> _todos = [];
  String _query = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  // ---- Lưu / tải bằng shared_preferences ----
  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw == null || !mounted) return;
    final list = (jsonDecode(raw) as List)
        .map((e) => Todo.fromJson(e as Map<String, dynamic>))
        .toList();
    setState(() => _todos
      ..clear()
      ..addAll(list));
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _storageKey,
      jsonEncode(_todos.map((t) => t.toJson()).toList()),
    );
  }

  // ---- Danh sách hiển thị: lọc theo tiêu đề + sắp xếp priority cao -> thấp ----
  List<Todo> get _visibleTodos {
    final q = _query.trim().toLowerCase();
    final list = _todos
        .where((t) => t.title.toLowerCase().contains(q))
        .toList();
    list.sort((a, b) {
      final byPriority = b.priority.index.compareTo(a.priority.index);
      if (byPriority != 0) return byPriority;
      return b.createdAt.compareTo(a.createdAt); // cùng mức: mới nhất trước
    });
    return list;
  }

  Future<void> _openAdd() async {
    // Đợi Todo trả về từ màn Add
    final result = await Navigator.push<Todo>(
      context,
      MaterialPageRoute(builder: (_) => const AddTodoPage()),
    );
    if (!mounted || result == null) return; // back mà không lưu => bỏ qua
    setState(() => _todos.add(result));
    _save();
  }

  Future<void> _openDetail(Todo todo) async {
    final result = await Navigator.push<TodoResult>(
      context,
      MaterialPageRoute(builder: (_) => TodoDetailPage(todo: todo)),
    );
    if (!mounted || result == null) return;
    setState(() {
      // sealed class => switch bắt buộc xử lý đủ mọi nhánh
      switch (result) {
        case TodoDeleted(:final id):
          _todos.removeWhere((t) => t.id == id);
        case TodoUpdated(todo: final updated):
          final i = _todos.indexWhere((t) => t.id == updated.id);
          if (i != -1) _todos[i] = updated;
      }
    });
    _save();
  }

  // Vuốt để xoá nhanh, có nút Hoàn tác
  void _dismiss(Todo todo) {
    final index = _todos.indexWhere((t) => t.id == todo.id);
    setState(() => _todos.removeWhere((t) => t.id == todo.id));
    _save();
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('Đã xoá "${todo.title}"'),
          action: SnackBarAction(
            label: 'Hoàn tác',
            onPressed: () {
              setState(() => _todos.insert(
                  index.clamp(0, _todos.length), todo));
              _save();
            },
          ),
        ),
      );
  }

  Color _priorityColor(Priority p) => switch (p) {
        Priority.low => Colors.green,
        Priority.medium => Colors.orange,
        Priority.high => Colors.red,
      };

  Widget _empty(IconData icon, String text) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: Colors.grey),
            const SizedBox(height: 8),
            Text(text),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    final visible = _visibleTodos;
    return Scaffold(
      appBar: AppBar(title: const Text('Todo')),
      body: Column(
        children: [
          // Thanh tìm kiếm theo tiêu đề
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: TextField(
              onChanged: (v) => setState(() => _query = v),
              decoration: const InputDecoration(
                hintText: 'Tìm theo tiêu đề...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
          ),
          Expanded(
            child: _todos.isEmpty
                ? _empty(Icons.checklist, 'Chưa có todo')
                : visible.isEmpty
                    ? _empty(Icons.search_off, 'Không tìm thấy todo')
                    : ListView.builder(
                        itemCount: visible.length,
                        itemBuilder: (context, i) {
                          final todo = visible[i];
                          return Dismissible(
                            key: ValueKey(todo.id),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              child:
                                  const Icon(Icons.delete, color: Colors.white),
                            ),
                            onDismissed: (_) => _dismiss(todo),
                            child: ListTile(
                              leading: Icon(Icons.flag,
                                  color: _priorityColor(todo.priority)),
                              title: Text(todo.title),
                              subtitle:
                                  Text('Ưu tiên: ${todo.priority.label}'),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () => _openDetail(todo),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAdd,
        child: const Icon(Icons.add),
      ),
    );
  }
}