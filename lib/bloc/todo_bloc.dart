import 'package:animations/bloc/todo_event.dart';
import 'package:animations/bloc/todo_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc() : super(TodoState(todos: [])) {
    // Add
    on<AddTodo>((event, emit) {
      final updated = List<Todo>.from(state.todos)
        ..add(Todo(title: event.title));
      emit(TodoState(todos: updated));
    });

    // Delete
    on<DeleteTodo>((event, emit) {
      final updated = List<Todo>.from(state.todos)..removeAt(event.index);
      emit(TodoState(todos: updated));
    });

    // Toggle
    on<ToggleTodo>((event, emit) {
      final updated = List<Todo>.from(state.todos);
      updated[event.index] = Todo(
        title: updated[event.index].title,
        isCompleted: !updated[event.index].isCompleted,
      );
      emit(TodoState(todos: updated));
    });

    // Edit
    on<EditTodo>((event, emit) {
      final updated = List<Todo>.from(state.todos);
      updated[event.index] = Todo(
        title: event.newTitle,
        isCompleted: updated[event.index].isCompleted,
      );
      emit(TodoState(todos: updated));
    });
  }
}
