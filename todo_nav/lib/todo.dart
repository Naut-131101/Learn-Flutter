enum Priority { low, medium, high }

// Extension giúp lấy nhãn tiếng Việt cho từng mức ưu tiên
extension PriorityLabel on Priority {
  String get label => switch (this) {
        Priority.low => 'Thấp',
        Priority.medium => 'Trung bình',
        Priority.high => 'Cao',
      };
}

class Todo {
  final int id;
  final String title;
  final String description;
  final Priority priority;
  final DateTime createdAt;

  Todo({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.createdAt,
  });

  // copyWith: tạo bản sao, chỉ thay field cần đổi - giữ nguyên id và createdAt
  Todo copyWith({String? title, String? description, Priority? priority}) =>
      Todo(
        id: id,
        title: title ?? this.title,
        description: description ?? this.description,
        priority: priority ?? this.priority,
        createdAt: createdAt,
      );

  // Chuyển sang/từ JSON để lưu bằng shared_preferences
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'priority': priority.name,
        'createdAt': createdAt.toIso8601String(),
      };

  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
        id: json['id'] as int,
        title: json['title'] as String,
        description: json['description'] as String,
        priority: Priority.values.byName(json['priority'] as String),
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}

// Kết quả mà màn hình Detail trả về cho List khi pop.
// sealed => switch bên List sẽ exhaustive (bắt buộc xử lý đủ mọi case).
sealed class TodoResult {}

class TodoDeleted extends TodoResult {
  final int id;
  TodoDeleted(this.id);
}

class TodoUpdated extends TodoResult {
  final Todo todo;
  TodoUpdated(this.todo);
}