import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:fluttergarden/features/todo/todo.dart';
import 'package:fluttergarden/features/todo/todo_repository.dart';

enum TodoError { loadFailed, saveFailed }

class TodoViewModel extends ChangeNotifier {
  TodoViewModel(this._repository);

  final TodoRepository _repository;
  final List<Todo> _todos = [];
  late final List<Todo> _readonlyTodos = UnmodifiableListView(_todos);

  int _nextId = 0;
  bool _showOnlyIncomplete = false;
  bool _isLoading = false;
  TodoError? _error;

  List<Todo> get todos => _readonlyTodos;
  bool get showOnlyIncomplete => _showOnlyIncomplete;
  bool get isLoading => _isLoading;
  TodoError? get error => _error;
  List<Todo> get visibleTodos => _showOnlyIncomplete
      ? _todos.where((todo) => !todo.completed).toList(growable: false)
      : _readonlyTodos;

  Future<void> loadTodos() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final todos = await _repository.loadTodos();
      _todos
        ..clear()
        ..addAll(todos);
      _nextId = _todos.fold(
        0,
        (nextId, todo) => todo.id >= nextId ? todo.id + 1 : nextId,
      );
    } on Object {
      _error = TodoError.loadFailed;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addTodo(String title) async {
    final trimmedTitle = title.trim();
    if (trimmedTitle.isEmpty) {
      return false;
    }

    _todos.add(Todo(id: _nextId++, title: trimmedTitle));
    notifyListeners();
    await _saveTodos();
    return true;
  }

  Future<void> toggleTodo(int id) async {
    final index = _todos.indexWhere((todo) => todo.id == id);
    if (index == -1) {
      return;
    }

    final todo = _todos[index];
    _todos[index] = todo.copyWith(completed: !todo.completed);
    notifyListeners();
    await _saveTodos();
  }

  Future<void> removeTodo(int id) async {
    final index = _todos.indexWhere((todo) => todo.id == id);
    if (index == -1) {
      return;
    }

    _todos.removeAt(index);
    notifyListeners();
    await _saveTodos();
  }

  void setShowOnlyIncomplete(bool value) {
    if (_showOnlyIncomplete == value) {
      return;
    }

    _showOnlyIncomplete = value;
    notifyListeners();
  }

  Future<void> _saveTodos() async {
    final previousError = _error;
    try {
      await _repository.saveTodos(List.of(_todos));
      _error = null;
    } on Object {
      _error = TodoError.saveFailed;
    }
    if (_error != previousError) {
      notifyListeners();
    }
  }
}
