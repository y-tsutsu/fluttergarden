import 'package:flutter/material.dart';
import 'package:fluttergarden/features/todo/todo.dart';
import 'package:fluttergarden/features/todo/todo_view_model.dart';
import 'package:provider/provider.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _addTodo(TodoViewModel viewModel) {
    if (viewModel.addTodo(_textController.text)) {
      _textController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<TodoViewModel>();
    final visibleTodos = viewModel.visibleTodos;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'New ToDo',
                      ),
                      onSubmitted: (_) => _addTodo(viewModel),
                    ),
                  ),
                  const SizedBox(width: 16),
                  FilledButton(
                    onPressed: () => _addTodo(viewModel),
                    child: const Text('Add'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Show only incomplete'),
                value: viewModel.showOnlyIncomplete,
                onChanged: viewModel.setShowOnlyIncomplete,
              ),
              const SizedBox(height: 8),
              Expanded(
                child: visibleTodos.isEmpty
                    ? const Center(child: Text('No ToDos'))
                    : ListView.builder(
                        itemCount: visibleTodos.length,
                        itemBuilder: (context, index) {
                          final todo = visibleTodos[index];
                          return _TodoListItem(
                            key: ValueKey(todo.id),
                            todo: todo,
                            onToggle: () => viewModel.toggleTodo(todo.id),
                            onRemove: () => viewModel.removeTodo(todo.id),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TodoListItem extends StatelessWidget {
  const _TodoListItem({
    super.key,
    required this.todo,
    required this.onToggle,
    required this.onRemove,
  });

  final Todo todo;
  final VoidCallback onToggle;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(value: todo.completed, onChanged: (_) => onToggle()),
      title: Text(
        todo.title,
        style: TextStyle(
          decoration: todo.completed ? TextDecoration.lineThrough : null,
        ),
      ),
      trailing: IconButton(
        tooltip: 'Delete',
        onPressed: onRemove,
        icon: const Icon(Icons.delete_outline),
      ),
    );
  }
}
