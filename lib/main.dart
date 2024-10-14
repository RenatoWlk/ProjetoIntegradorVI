import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:projeto_integrador_6/providers/invoice_provider.dart';
// import 'package:projeto_integrador_6/screens/home_screen.dart';
import 'package:projeto_integrador_6/screens/login_screen.dart';
import 'package:projeto_integrador_6/services/database/database.dart';
import 'package:provider/provider.dart';
import 'routes/app_routes.dart';
import 'services/camera_service.dart';
import 'services/ocr_service.dart';
import 'providers/ocr_provider.dart';
import 'providers/invoice_items_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MongoDatabase.connect();
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
        ),
        ChangeNotifierProvider<InvoiceItemsProvider>(
          create: (context) => InvoiceItemsProvider(),
        ),
        ChangeNotifierProvider<InvoiceProvider>(
          create: (context) => InvoiceProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'ANDRÉ MENDELECK LTDA.',
        theme: ThemeData(
          primarySwatch: Colors.grey,
        ),
        home: const LoginScreen(),
        // home: HomeScreen(camera: camera),
        routes: AppRoutes.define(camera),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
