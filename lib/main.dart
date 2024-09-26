import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'screens/home_screen.dart';
import 'routes/app_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;

  runApp(App(camera: firstCamera));
}

class App extends StatelessWidget {
  final CameraDescription camera;

  const App({super.key, required this.camera});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Projeto Integrador VI',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: HomeScreen(camera: camera),
      routes: AppRoutes.define(camera),
      debugShowCheckedModeBanner: false,
    );
  }
}