import 'package:flutter_test/flutter_test.dart';
import 'package:fluttergarden/features/todo/todo.dart';
import 'package:fluttergarden/features/todo/todo_view_model.dart';

void main() {
  late TodoViewModel viewModel;

  setUp(() {
    viewModel = TodoViewModel();
  });

  test('初期状態でToDoが空', () {
    expect(viewModel.todos, isEmpty);
    expect(viewModel.showOnlyIncomplete, isFalse);
  });

  test('ToDoを追加できる', () {
    expect(viewModel.addTodo('  Buy milk  '), isTrue);

    expect(viewModel.todos, hasLength(1));
    expect(viewModel.todos.single.title, 'Buy milk');
    expect(viewModel.todos.single.completed, isFalse);
  });

  test('空白だけのToDoは追加しない', () {
    expect(viewModel.addTodo('   '), isFalse);
    expect(viewModel.todos, isEmpty);
  });

  test('ToDoの完了状態を切り替えられる', () {
    viewModel.addTodo('Buy milk');
    final originalTodo = viewModel.todos.single;

    viewModel.toggleTodo(originalTodo.id);

    expect(viewModel.todos.single.completed, isTrue);
    expect(identical(viewModel.todos.single, originalTodo), isFalse);
  });

  test('ToDoを削除できる', () {
    viewModel.addTodo('Buy milk');
    final id = viewModel.todos.single.id;

    viewModel.removeTodo(id);

    expect(viewModel.todos, isEmpty);
  });

  test('未完了のToDoだけを取得できる', () {
    viewModel.addTodo('Completed');
    viewModel.addTodo('Incomplete');
    viewModel.toggleTodo(viewModel.todos.first.id);

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
}
