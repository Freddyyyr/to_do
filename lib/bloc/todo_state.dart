class Todo {
  String title;
  bool isCompleted;

  Todo({required this.title, this.isCompleted = false});
}

class TodoState {
  List<Todo> todos;

  TodoState({required this.todos});
}
