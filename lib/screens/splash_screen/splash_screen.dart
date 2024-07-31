import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:todo_app/screens/auth_screen/login.dart';
import 'package:todo_app/screens/main_screen/main_screen.dart';
import 'package:todo_app/utils/navigation/custom_navigation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (user == null) {
          Logger().f('User is currently signed out!');
          CustomNavigation.nextPage(context, const LoginScreen());
        } else {
          Logger().e('User is signed in!');
          CustomNavigation.nextPage(context, const MainScreen());
        }
      });
    });
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
