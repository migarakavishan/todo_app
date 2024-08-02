import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/models/user_model.dart';
import 'package:todo_app/providers/auth_provider.dart' as auth_provider;
import 'package:todo_app/screens/auth_screen/login.dart';
import 'package:todo_app/screens/main_screen/main_screen.dart';
import 'package:todo_app/utils/navigation/custom_navigation.dart';

class AuthController {
  CollectionReference users = FirebaseFirestore.instance.collection("Users");

  Future<void> listenAuthState(BuildContext context) async {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        Logger().f('User is currently signed out!');
        CustomNavigation.nextPage(context, const LoginScreen());
      } else {
        Provider.of<auth_provider.AuthProvider>(context, listen: false)
            .setUser(user);
        Logger().e('User is signed in!');
        fetchUserData(user.uid).then((value) {
          if (value != null) {
            Provider.of<auth_provider.AuthProvider>(context, listen: false)
                .setUserModel(value);
            CustomNavigation.nextPage(context, const MainScreen());
          } else {
            Provider.of<auth_provider.AuthProvider>(context, listen: false)
                .setUserModel(
                    UserModel(email: user.uid, name: "", uid: user.uid));
            CustomNavigation.nextPage(context, const MainScreen());
          }
        });
      }
    });
  }

  Future<void> createAccount(
      {required String email,
      required String password,
      required String name}) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user != null) {
        UserModel model =
            UserModel(email: email, name: name, uid: credential.user!.uid);
        addUserData(model);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Logger().e('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        Logger().e('The account already exists for that email.');
      }
    } catch (e) {
      Logger().e(e);
    }
  }

  Future<void> signOutUser() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<void> signInWithPassword(
      {required String email, required String password}) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Logger().e('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        Logger().e('Wrong password provided for that user.');
      }
    }
  }

  Future<void> addUserData(UserModel user) async {
    try {
      await users.doc(user.uid).set(user.toJson());
      Logger().f("User Data Added");
    } catch (e) {
      Logger().e(e);
    }
  }

  Future<UserModel?> fetchUserData(String uid) async {
    try {
      DocumentSnapshot snapshot = await users.doc(uid).get();
      return UserModel.fromJson(snapshot.data() as Map<String, dynamic>);
    } catch (e) {
      Logger().e(e);
      return null;
    }
  }

  Future<void> addTodoItem(ToDoModel todo) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await users.doc(user.uid).collection('todos').add(todo.toJson());
        Logger().e("Todo added successfully.");
      } catch (e) {
        Logger().e("Failed to add todo: $e");
      }
    }
  }

  Future<void> updateTodoStatus(String todoId, bool isDone) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await users.doc(user.uid).collection('todos').doc(todoId).update({'isDone': isDone});
        Logger().e("Todo status updated.");
      } catch (e) {
       Logger().e("Failed to update todo status: $e");
      }
    }
  }

  Future<void> deleteTodoItem(String todoId) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await users.doc(user.uid).collection('todos').doc(todoId).delete();
        Logger().e("Todo deleted successfully.");
      } catch (e) {
        Logger().e("Failed to delete todo: $e");
      }
    }
  }
}

