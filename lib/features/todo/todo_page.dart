import 'package:flutter/material.dart';
import 'package:fluttergarden/features/todo/todo.dart';
import 'package:fluttergarden/features/todo/todo_edit_page.dart';
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

  Future<void> _addTodo(TodoViewModel viewModel) async {
    final added = await viewModel.addTodo(_textController.text);
    if (added && mounted) {
      _textController.clear();
    }
  }

  Future<void> _editTodo(TodoViewModel viewModel, Todo todo) async {
    final title = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (context) => TodoEditPage(todo: todo)),
    );
    if (title != null && mounted) {
      await viewModel.updateTodoTitle(todo.id, title);
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<TodoViewModel>();
    final visibleTodos = viewModel.visibleTodos;
    final errorMessage = switch (viewModel.error) {
      TodoError.loadFailed => 'Failed to load ToDos',
      TodoError.saveFailed => 'Failed to save ToDos',
      null => null,
    };

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
                      enabled: !viewModel.isLoading,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'New ToDo',
                      ),
                      onSubmitted: (_) => _addTodo(viewModel),
                    ),
                  ),
                  const SizedBox(width: 16),
                  FilledButton(
                    onPressed: viewModel.isLoading
                        ? null
                        : () => _addTodo(viewModel),
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
              if (errorMessage != null)
                Text(
                  errorMessage,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              Expanded(
                child: viewModel.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : visibleTodos.isEmpty
                    ? const Center(child: Text('No ToDos'))
                    : ListView.builder(
                        itemCount: visibleTodos.length,
                        itemBuilder: (context, index) {
                          final todo = visibleTodos[index];
                          return _TodoListItem(
                            key: ValueKey(todo.id),
                            todo: todo,
                            onToggle: () => viewModel.toggleTodo(todo.id),
                            onTap: () => _editTodo(viewModel, todo),
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
    required this.onTap,
    required this.onRemove,
  });

  final Todo todo;
  final VoidCallback onToggle;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
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
