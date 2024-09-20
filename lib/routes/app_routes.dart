import 'package:flutter/material.dart';
import 'package:projeto_integrador_6/screens/home_screen.dart';

class AppRoutes {
  static const String home = '/home';

  static Map<String, WidgetBuilder> define() {
    return {
      home: (context) => const HomeScreen(),
    };
  }
}

// fazer rota pra login e ler notinha