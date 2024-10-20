import 'package:flutter/material.dart';

import 'package:projeto_integrador_6/screens/home_screen.dart';
import 'package:projeto_integrador_6/screens/login_screen.dart';
import 'package:projeto_integrador_6/screens/register_screen.dart';
import 'package:projeto_integrador_6/screens/list_screen.dart';
import 'package:projeto_integrador_6/screens/history_screen.dart';
import 'package:projeto_integrador_6/screens/update_password_screen.dart';

class AppRoutes {
  static const String home = '/home';
  static const String login = '/login';
  static const String register = '/register';
  static const String list = '/list';
  static const String history = '/history';
  static const String updatePassword = '/update_password';

  static Map<String, WidgetBuilder> define() {
    return {
      home: (context) => const HomeScreen(),
      login: (context) => const LoginScreen(),
      register: (context) => const RegisterScreen(),
      list: (context) => const ListScreen(),
      history: (context) => const HistoryScreen(),
      updatePassword: (context) => const UpdatePasswordScreen()
    };
  }
}
