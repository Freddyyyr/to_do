import 'package:animations/bloc/todo_bloc.dart';
import 'package:animations/bloc/todo_event.dart';
import 'package:animations/bloc/todo_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<void> _showTodoDialog({
    String? initialText,
    required Function(String) onSave,
  }) async {
    final TextEditingController dialogController = TextEditingController(
      text: initialText ?? '',
    );
    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(initialText == null ? 'Add Todo' : 'Edit Todo'),
          content: TextField(
            controller: dialogController,
            decoration: const InputDecoration(hintText: 'Enter your todo'),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                  Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
              onPressed: () {
                if (dialogController.text.trim().isNotEmpty) {
                  Navigator.of(context).pop(dialogController.text.trim());
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
    if (result != null && result.isNotEmpty) {
      onSave(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 16),
              Expanded(
                child: BlocBuilder<TodoBloc, TodoState>(
                  builder: (context, state) {
                    if (state.todos.isEmpty) {
                      return Center(child: Text("No list"));
                    }
                    return ListView.builder(
                      itemCount: state.todos.length,
                      itemBuilder: (context, index) {
                        final todo = state.todos[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Dismissible(
                            key: ValueKey(todo),
                            direction: DismissDirection.horizontal,
                            background: Container(
                              color: Colors.blue,
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.only(left: 20),
                              child: const Icon(
                                Icons.edit,
                                color: Colors.white,
                              ),
                            ),
                            secondaryBackground: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                            confirmDismiss: (direction) async {
                              if (direction == DismissDirection.startToEnd) {
                                // Edit Todo
                                await _showTodoDialog(
                                  initialText: todo.title,
                                  onSave: (newTitle) {
                                    context.read<TodoBloc>().add(
                                      EditTodo(
                                        index: index,
                                        newTitle: newTitle,
                                      ),
                                    );
                                  },
                                );
                                return false; // Prevent dismiss
                              } else if (direction ==
                                  DismissDirection.endToStart) {
                                // Delete Todo
                                return true; // Allow dismiss
                              }
                              return false;
                            },
                            onDismissed: (direction) {
                              if (direction == DismissDirection.endToStart) {
                                context.read<TodoBloc>().add(
                                  DeleteTodo(index: index),
                                );
                              }
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 1000),
                              decoration: BoxDecoration(
                                color: todo.isCompleted
                                    ? Colors.green
                                    : const Color.fromARGB(255, 25, 45, 25),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: ListTile(
                                title: Text(todo.title),
                                onTap: () => context.read<TodoBloc>().add(
                                  ToggleTodo(index: index),
                                ),
                                leading: Checkbox(
                                  value: todo.isCompleted,
                                  onChanged: (_) {
                                    context.read<TodoBloc>().add(
                                      ToggleTodo(index: index),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showTodoDialog(
            onSave: (text) {
              context.read<TodoBloc>().add(AddTodo(title: text));
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
// ...existing code...