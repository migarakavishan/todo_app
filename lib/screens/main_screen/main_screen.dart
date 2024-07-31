import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/controllers/auth_controller.dart';
import 'package:todo_app/providers/auth_provider.dart';
import 'package:todo_app/providers/todo_provider.dart';
import 'package:todo_app/screens/main_screen/widgets/todo_item.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final provider = Provider.of<ToDoProvider>(context);
    final undoneTodos = provider.todos.where((todo) => !todo.isDone).toList();
    final doneTodos = provider.todos.where((todo) => todo.isDone).toList();

    return Scaffold(
      backgroundColor: Colors.blue,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 80,
              width: size.width,
              decoration: const BoxDecoration(color: Colors.blue),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    const Center(
                        child: Text(
                      "ToDoList",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    )),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        AuthController().signOutUser();
                      },
                      child: const CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.exit_to_app,
                          color: Colors.blue,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                "Hello ${Provider.of<AuthProvider>(context).userModel!.name}",
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
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
                      onToggle: () => provider.toggleToDoStatus(
                          provider.todos.indexOf(undoneTodos[todoIndex])),
                      onDelete: () => provider.removeToDoItem(
                          provider.todos.indexOf(undoneTodos[todoIndex])),
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
                      onToggle: () => provider.toggleToDoStatus(
                          provider.todos.indexOf(doneTodos[todoIndex])),
                      onDelete: () => provider.removeToDoItem(
                          provider.todos.indexOf(doneTodos[todoIndex])),
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
                    onPressed: () {
                      provider.addToDo(_textController.text);
                      _textController.clear();
                    },
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
