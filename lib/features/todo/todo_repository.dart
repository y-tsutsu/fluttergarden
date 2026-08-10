import 'package:fluttergarden/features/todo/todo.dart';

abstract interface class TodoRepository {
  Future<List<Todo>> loadTodos();

  Future<void> saveTodos(List<Todo> todos);
}
