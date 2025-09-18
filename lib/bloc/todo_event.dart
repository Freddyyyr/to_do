abstract class TodoEvent {}

class AddTodo extends TodoEvent {
  final String title;
  AddTodo({required this.title});
}

class DeleteTodo extends TodoEvent {
  final int index;
  DeleteTodo({required this.index});
}

class ToggleTodo extends TodoEvent {
  final int index;
  ToggleTodo({required this.index});
}

class EditTodo extends TodoEvent {
  final int index;
  final String newTitle;
  EditTodo({required this.index, required this.newTitle});
}
