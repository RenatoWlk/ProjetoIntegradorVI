import 'package:flutter/material.dart';
import 'package:projeto_integrador_6/screens/home_screen.dart';
import 'package:projeto_integrador_6/screens/login_screen.dart';
import 'package:projeto_integrador_6/screens/register_screen.dart';
import 'package:projeto_integrador_6/screens/scan_screen.dart';

class AppRoutes {
  static const String home = '/home';
  static const String login = '/login';
  static const String register = '/register';
  static const String scanInvoice = '/scanInvoice';

  static Map<String, WidgetBuilder> define() {
    return {
      home: (context) => const HomeScreen(),
      login: (context) => const LoginScreen(),
      register: (context) => const RegisterScreen(),
      scanInvoice: (context) => const ScanInvoiceScreen(),
    };
  }
}