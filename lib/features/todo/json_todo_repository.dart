import 'dart:convert';
import 'dart:io';

import 'package:fluttergarden/features/todo/todo.dart';
import 'package:fluttergarden/features/todo/todo_repository.dart';
import 'package:path_provider/path_provider.dart';

class JsonTodoRepository implements TodoRepository {
  JsonTodoRepository({Future<Directory> Function()? directoryProvider})
    : _directoryProvider = directoryProvider ?? getApplicationSupportDirectory;

  static const String fileName = 'todos.json';

  final Future<Directory> Function() _directoryProvider;
  Future<void> _pendingSave = Future.value();

  Future<File> _getFile() async {
    final directory = await _directoryProvider();
    await directory.create(recursive: true);
    return File('${directory.path}${Platform.pathSeparator}$fileName');
  }

  @override
  Future<List<Todo>> loadTodos() async {
    try {
      await _pendingSave;
    } on Object {
      // A previous save error must not prevent reloading from the file.
    }

    final file = await _getFile();
    if (!await file.exists()) {
      return [];
    }

    final contents = await file.readAsString();
    final json = jsonDecode(contents);
    if (json is! List<Object?>) {
      throw const FormatException('Todo JSON must be a list');
    }

    return json
        .map((item) {
          if (item is! Map<String, Object?>) {
            throw const FormatException('Invalid Todo JSON item');
          }
          return Todo.fromJson(item);
        })
        .toList(growable: false);
  }

  @override
  Future<void> saveTodos(List<Todo> todos) {
    final json = todos.map((todo) => todo.toJson()).toList(growable: false);
    final contents = jsonEncode(json);
    _pendingSave = _pendingSave.then(
      (_) => _write(contents),
      onError: (_) => _write(contents),
    );
    return _pendingSave;
  }

  Future<void> _write(String contents) async {
    final file = await _getFile();
    await file.writeAsString(contents, flush: true);
  }
}
