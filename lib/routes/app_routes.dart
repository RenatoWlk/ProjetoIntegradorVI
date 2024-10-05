import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import 'package:projeto_integrador_6/screens/home_screen.dart';
import 'package:projeto_integrador_6/screens/login_screen.dart';
import 'package:projeto_integrador_6/screens/register_screen.dart';
import 'package:projeto_integrador_6/screens/list_screen.dart';
import 'package:projeto_integrador_6/screens/history_screen.dart';

class AppRoutes {
  static const String home = '/home';
  static const String login = '/login';
  static const String register = '/register';
  static const String list = '/list';
  static const String history = '/history';

  static Map<String, WidgetBuilder> define(CameraDescription camera) {
    return {
      home: (context) => HomeScreen(camera: camera),
      login: (context) => const LoginScreen(),
      register: (context) => const RegisterScreen(),
      list: (context) => const ListScreen(),
      history: (context) => const HistoryScreen()
    };
  }
}