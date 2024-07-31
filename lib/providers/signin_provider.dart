import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:todo_app/controllers/auth_controller.dart';

class SigninProvider extends ChangeNotifier {
  AuthController authController = AuthController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  TextEditingController get emailController => _emailController;
  TextEditingController get passwordController => _passwordController;

  Future<void> startsSignIn() async {
    if (_emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      Logger().e("Invalid data");
    } else {
      authController.signInWithPassword(
          email: _emailController.text, password: _passwordController.text);
    }
  }
}
