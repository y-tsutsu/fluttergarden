import 'package:flutter_test/flutter_test.dart';
import 'package:fluttergarden/features/todo/in_memory_todo_repository.dart';
import 'package:fluttergarden/features/todo/todo.dart';
import 'package:fluttergarden/features/todo/todo_repository.dart';
import 'package:fluttergarden/features/todo/todo_view_model.dart';

void main() {
  late TodoViewModel viewModel;

  setUp(() {
    viewModel = TodoViewModel(InMemoryTodoRepository());
  });

  test('初期状態でToDoが空', () {
    expect(viewModel.todos, isEmpty);
    expect(viewModel.showOnlyIncomplete, isFalse);
  });

  test('ToDoを追加できる', () async {
    expect(await viewModel.addTodo('  Buy milk  '), isTrue);

    expect(viewModel.todos, hasLength(1));
    expect(viewModel.todos.single.title, 'Buy milk');
    expect(viewModel.todos.single.completed, isFalse);
  });

  test('空白だけのToDoは追加しない', () async {
    expect(await viewModel.addTodo('   '), isFalse);
    expect(viewModel.todos, isEmpty);
  });

  test('ToDoの完了状態を切り替えられる', () async {
    await viewModel.addTodo('Buy milk');
    final originalTodo = viewModel.todos.single;

    await viewModel.toggleTodo(originalTodo.id);

    expect(viewModel.todos.single.completed, isTrue);
    expect(identical(viewModel.todos.single, originalTodo), isFalse);
  });

  test('ToDoを削除できる', () async {
    await viewModel.addTodo('Buy milk');
    final id = viewModel.todos.single.id;

    await viewModel.removeTodo(id);

    expect(viewModel.todos, isEmpty);
  });

  test('未完了のToDoだけを取得できる', () async {
    await viewModel.addTodo('Completed');
    await viewModel.addTodo('Incomplete');
    await viewModel.toggleTodo(viewModel.todos.first.id);

    viewModel.setShowOnlyIncomplete(true);

    expect(viewModel.visibleTodos.map((todo) => todo.title), ['Incomplete']);
    expect(viewModel.todos, hasLength(2));
  });

  test('公開されたListは変更できない', () {
    expect(
      () => viewModel.todos.add(const Todo(id: 0, title: 'Buy milk')),
      throwsUnsupportedError,
    );
  });

  test('RepositoryからToDoを読み込める', () async {
    viewModel = TodoViewModel(
      InMemoryTodoRepository(
        initialTodos: const [Todo(id: 10, title: 'Loaded')],
      ),
    );

    await viewModel.loadTodos();
    await viewModel.addTodo('Next');

    expect(viewModel.todos.map((todo) => todo.title), ['Loaded', 'Next']);
    expect(viewModel.todos.last.id, 11);
    expect(viewModel.isLoading, isFalse);
    expect(viewModel.error, isNull);
  });

  test('Repositoryの読み込み失敗を通知できる', () async {
    viewModel = TodoViewModel(_FailingTodoRepository());

    await viewModel.loadTodos();

    expect(viewModel.isLoading, isFalse);
    expect(viewModel.error, TodoError.loadFailed);
  });

  test('Repositoryの保存失敗を通知できる', () async {
    viewModel = TodoViewModel(_FailingSaveTodoRepository());

    await viewModel.addTodo('Buy milk');

    expect(viewModel.error, TodoError.saveFailed);
  });
}

class _FailingTodoRepository implements TodoRepository {
  @override
  Future<List<Todo>> loadTodos() {
    throw Exception('load failed');
  }

  @override
  Future<void> saveTodos(List<Todo> todos) async {}
}

class _FailingSaveTodoRepository implements TodoRepository {
  @override
  Future<List<Todo>> loadTodos() async => [];

  @override
  Future<void> saveTodos(List<Todo> todos) {
    throw Exception('save failed');
  }
}
