import 'package:flutter/material.dart';
import 'package:todo_app/todo.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<ToDo> _todos = [];
  final TextEditingController _textController = TextEditingController();

  void _addToDo() {
    setState(() {
      _todos.add(ToDo(
        title: _textController.text,
      ));
      _textController.clear();
    });
  }

  void _toggleToDoStatus(int index) {
    setState(() {
      _todos[index].isDone = !_todos[index].isDone;
    });
  }

  void _removeToDoItem(int index) {
    setState(() {
      _todos.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final undoneTodos = _todos.where((todo) => !todo.isDone).toList();
    final doneTodos = _todos.where((todo) => todo.isDone).toList();

    return Scaffold(
      backgroundColor: Colors.blue,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 80,
              width: size.width,
              decoration: const BoxDecoration(color: Colors.blue),
              child: const Center(
                  child: Text(
                "ToDoList",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              )),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount:
                    undoneTodos.length + doneTodos.length + 2, // for headers
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Todo',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade300),
                      ),
                    );
                  } else if (index <= undoneTodos.length) {
                    final todoIndex = index - 1;
                    return ToDoItem(
                      todo: undoneTodos[todoIndex],
                      onToggle: () => _toggleToDoStatus(
                          _todos.indexOf(undoneTodos[todoIndex])),
                      onDelete: () => _removeToDoItem(
                          _todos.indexOf(undoneTodos[todoIndex])),
                    );
                  } else if (index == undoneTodos.length + 1) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Done',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade300),
                      ),
                    );
                  } else {
                    final todoIndex = index - undoneTodos.length - 2;
                    return ToDoItem(
                      todo: doneTodos[todoIndex],
                      onToggle: () => _toggleToDoStatus(
                          _todos.indexOf(doneTodos[todoIndex])),
                      onDelete: () =>
                          _removeToDoItem(_todos.indexOf(doneTodos[todoIndex])),
                    );
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                        hintText: 'Add new task',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FloatingActionButton(
                    shape: const CircleBorder(),
                    onPressed: _addToDo,
                    backgroundColor: Colors.white,
                    child: const Icon(
                      Icons.add,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ToDoItem extends StatelessWidget {
  final ToDo todo;
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
