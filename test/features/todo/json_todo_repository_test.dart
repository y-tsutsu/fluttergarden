import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:fluttergarden/features/todo/json_todo_repository.dart';
import 'package:fluttergarden/features/todo/todo.dart';

void main() {
  late Directory temporaryDirectory;
  late JsonTodoRepository repository;

  setUp(() async {
    temporaryDirectory = await Directory.systemTemp.createTemp(
      'fluttergarden_test_',
    );
    repository = JsonTodoRepository(
      directoryProvider: () async => temporaryDirectory,
    );
  });

  tearDown(() async {
    if (await temporaryDirectory.exists()) {
      await temporaryDirectory.delete(recursive: true);
    }
  });

  test('ファイルがない場合は空のListを返す', () async {
    expect(await repository.loadTodos(), isEmpty);
  });

  test('ToDoをJSONとして保存して読み込める', () async {
    const todos = [
      Todo(id: 1, title: 'Buy milk'),
      Todo(id: 2, title: 'Write code', completed: true),
    ];

    await repository.saveTodos(todos);
    final loadedTodos = await repository.loadTodos();

    expect(loadedTodos, hasLength(2));
    expect(loadedTodos[0].id, 1);
    expect(loadedTodos[0].title, 'Buy milk');
    expect(loadedTodos[0].completed, isFalse);
    expect(loadedTodos[1].id, 2);
    expect(loadedTodos[1].title, 'Write code');
    expect(loadedTodos[1].completed, isTrue);
  });

  test('不正なJSONの読み込みは失敗する', () async {
    final file = File(
      '${temporaryDirectory.path}${Platform.pathSeparator}'
      '${JsonTodoRepository.fileName}',
    );
    await file.writeAsString('{"id": 1}');

    expect(repository.loadTodos(), throwsFormatException);
  });

  test('連続した保存は最新の内容を残す', () async {
    final firstSave = repository.saveTodos(const [Todo(id: 0, title: 'First')]);
    final secondSave = repository.saveTodos(const [
      Todo(id: 0, title: 'First'),
      Todo(id: 1, title: 'Second'),
    ]);

    await Future.wait([firstSave, secondSave]);
    final loadedTodos = await repository.loadTodos();

    expect(loadedTodos.map((todo) => todo.title), ['First', 'Second']);
  });

  test('読み込みは進行中の保存完了後の内容を返す', () async {
    final save = repository.saveTodos(const [Todo(id: 0, title: 'Saved')]);

    final loadedTodos = await repository.loadTodos();
    await save;

    expect(loadedTodos.single.title, 'Saved');
  });
}
