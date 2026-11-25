import 'package:flutter/material.dart';
import 'todo.dart';

class AddTodoPage extends StatefulWidget {
  // null = thêm mới, khác null = sửa
  final Todo? existing;
  const AddTodoPage({super.key, this.existing});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descController;
  late Priority _priority;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    // Prefill từ todo đang sửa (nếu có)
    _titleController = TextEditingController(text: e?.title ?? '');
    _descController = TextEditingController(text: e?.description ?? '');
    _priority = e?.priority ?? Priority.medium;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final e = widget.existing;
    final todo = e == null
        ? Todo(
            id: DateTime.now().millisecondsSinceEpoch, // id mới đơn giản
            title: _titleController.text.trim(),
            description: _descController.text.trim(),
            priority: _priority,
            createdAt: DateTime.now(),
          )
        : e.copyWith(
            title: _titleController.text.trim(),
            description: _descController.text.trim(),
            priority: _priority,
          );
    Navigator.pop(context, todo); // trả Todo về màn hình trước
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existing != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Sửa todo' : 'Thêm todo')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Tiêu đề',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Vui lòng nhập tiêu đề' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Mô tả',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<Priority>(
                // API MỚI: initialValue thay cho value (deprecated sau 3.33)
                initialValue: _priority,
                decoration: const InputDecoration(
                  labelText: 'Độ ưu tiên',
                  border: OutlineInputBorder(),
                ),
                items: Priority.values
                    .map((p) =>
                        DropdownMenuItem(value: p, child: Text(p.label)))
                    .toList(),
                onChanged: (p) => setState(() => _priority = p ?? _priority),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _save,
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                child: const Text('Lưu'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
