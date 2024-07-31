import 'package:flutter/material.dart';
import 'package:todo_app/models/todo_model.dart';

class ToDoProvider extends ChangeNotifier {
  final List<ToDoModel> _todos = [];

  List<ToDoModel> get todos => _todos;

  void addToDo(String title) {
    _todos.add(ToDoModel(title: title));
    notifyListeners();
  }

  void toggleToDoStatus(int index) {
    _todos[index].isDone = !_todos[index].isDone;
    notifyListeners();
  }

  void removeToDoItem(int index) {
    _todos.removeAt(index);
    notifyListeners();
  }
}
