class Todo {
  const Todo({required this.id, required this.title, this.completed = false});

  final int id;
  final String title;
  final bool completed;

  factory Todo.fromJson(Map<String, Object?> json) {
    final id = json['id'];
    final title = json['title'];
    final completed = json['completed'];
    if (id is! int || title is! String || completed is! bool) {
      throw const FormatException('Invalid Todo JSON');
    }

    return Todo(id: id, title: title, completed: completed);
  }

  Map<String, Object?> toJson() {
    return {'id': id, 'title': title, 'completed': completed};
  }

  Todo copyWith({String? title, bool? completed}) {
    return Todo(
      id: id,
      title: title ?? this.title,
      completed: completed ?? this.completed,
    );
  }
}
