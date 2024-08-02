import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/models/todo_model.dart';

class ToDoProvider extends ChangeNotifier {
  final List<ToDoModel> _todos = [];
  List<ToDoModel> get todos => _todos;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? _user = FirebaseAuth.instance.currentUser;

  void loadToDos() async {
    if (_user != null) {
      QuerySnapshot snapshot = await _firestore
          .collection('Users')
          .doc(_user.uid)
          .collection('todos')
          .get();

      var todos = snapshot.docs
          .map((doc) => ToDoModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      _todos.clear();
      _todos.addAll(todos);
      notifyListeners();
    }
  }

  void addToDo(String title) {
    ToDoModel newTodo = ToDoModel(title: title);
    if (_user != null) {
      _firestore
          .collection('Users')
          .doc(_user.uid)
          .collection('todos')
          .add(newTodo.toJson());
    }
    _todos.add(newTodo);
    notifyListeners();
  }

  void toggleToDoStatus(String todoId) {
    var todo = _todos.firstWhere((t) => t.id == todoId);
    todo.isDone = !todo.isDone;
    _firestore
        .collection('Users')
        .doc(_user!.uid)
        .collection('todos')
        .doc(todoId)
        .update({'isDone': todo.isDone});
    notifyListeners();
  }

  void removeToDoItem(String todoId) {
    _todos.removeWhere((t) => t.id == todoId);
    _firestore
        .collection('Users')
        .doc(_user!.uid)
        .collection('todos')
        .doc(todoId)
        .delete();
    notifyListeners();
  }
}
