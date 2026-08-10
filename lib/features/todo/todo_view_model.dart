import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:fluttergarden/features/todo/todo.dart';

class TodoViewModel extends ChangeNotifier {
  final List<Todo> _todos = [];
  late final List<Todo> _readonlyTodos = UnmodifiableListView(_todos);

  int _nextId = 0;
  bool _showOnlyIncomplete = false;

  List<Todo> get todos => _readonlyTodos;
  bool get showOnlyIncomplete => _showOnlyIncomplete;
  List<Todo> get visibleTodos => _showOnlyIncomplete
      ? _todos.where((todo) => !todo.completed).toList(growable: false)
      : _readonlyTodos;

  bool addTodo(String title) {
    final trimmedTitle = title.trim();
    if (trimmedTitle.isEmpty) {
      return false;
    }

    _todos.add(Todo(id: _nextId++, title: trimmedTitle));
    notifyListeners();
    return true;
  }

  void toggleTodo(int id) {
    final index = _todos.indexWhere((todo) => todo.id == id);
    if (index == -1) {
      return;
    }

    final todo = _todos[index];
    _todos[index] = todo.copyWith(completed: !todo.completed);
    notifyListeners();
  }

  void removeTodo(int id) {
    final index = _todos.indexWhere((todo) => todo.id == id);
    if (index == -1) {
      return;
    }

    _todos.removeAt(index);
    notifyListeners();
  }

  void setShowOnlyIncomplete(bool value) {
    if (_showOnlyIncomplete == value) {
      return;
    }

    _showOnlyIncomplete = value;
    notifyListeners();
  }
}
