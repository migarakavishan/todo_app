import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/screens/main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 2),
      () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MainScreen(),
            ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.blue,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.check,
                color: Colors.blue,
                size: 70,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "ToDoList",
            style: TextStyle(
                fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 30,
          ),
          CupertinoActivityIndicator(
            color: Colors.white,
          )
        ],
      ),
    );
  }
}
