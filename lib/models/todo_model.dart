// lib/todo.dart
class ToDoModel {
  String title;
  bool isDone;

  ToDoModel({
    required this.title,
    this.isDone = false,
  });
}
