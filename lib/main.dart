import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'routes/app_routes.dart';
import 'services/camera_service.dart';
import 'services/ocr_service.dart';
import 'providers/ocr_provider.dart';

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
    return MultiProvider(
      providers: [
        Provider<OCRService>(
          create: (_) => OCRService(),
        ),
        ChangeNotifierProvider<OCRProvider>(
          create: (_) => OCRProvider(),
        ),
        ChangeNotifierProvider<CameraService>(
          create: (_) => CameraService(),
        )
      ],
      child: MaterialApp(
        title: 'Projeto Integrador VI',
        theme: ThemeData(
          primarySwatch: Colors.grey,
        ),
        home: HomeScreen(camera: camera),
        routes: AppRoutes.define(camera),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}