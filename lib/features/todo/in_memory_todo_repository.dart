import 'package:fluttergarden/features/todo/todo.dart';
import 'package:fluttergarden/features/todo/todo_repository.dart';

class InMemoryTodoRepository implements TodoRepository {
  InMemoryTodoRepository({List<Todo> initialTodos = const []})
    : _todos = List.of(initialTodos);

  List<Todo> _todos;

  @override
  Future<List<Todo>> loadTodos() async {
    return List.unmodifiable(_todos);
  }

  @override
  Future<void> saveTodos(List<Todo> todos) async {
    _todos = List.of(todos);
  }
}
