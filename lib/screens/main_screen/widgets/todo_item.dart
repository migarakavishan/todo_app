import 'package:flutter/material.dart';
import 'package:todo_app/models/todo_model.dart';

class ToDoItem extends StatelessWidget {
  final ToDoModel todo;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const ToDoItem({
    super.key,
    required this.todo,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        tileColor: Colors.white,
        title: Text(
          todo.title,
          style: TextStyle(
            decoration: todo.isDone ? TextDecoration.lineThrough : null,
          ),
        ),
        leading: Checkbox(
          value: todo.isDone,
          onChanged: (value) => onToggle(),
          shape: const CircleBorder(),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
