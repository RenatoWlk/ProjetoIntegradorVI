import 'dart:async';
import 'package:flutter/material.dart';
import 'package:projeto_integrador_6/providers/invoice_provider.dart';
import 'package:projeto_integrador_6/providers/user_provider.dart';
//import 'package:projeto_integrador_6/screens/home_screen.dart';
import 'package:projeto_integrador_6/screens/login_screen.dart';
import 'package:projeto_integrador_6/services/database/database.dart';
import 'package:provider/provider.dart';
import 'routes/app_routes.dart';
import 'services/ocr_service.dart';
import 'providers/ocr_provider.dart';
import 'providers/invoice_items_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MongoDatabase.connect();

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

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
        ChangeNotifierProvider<InvoiceItemsProvider>(
          create: (context) => InvoiceItemsProvider(),
        ),
        ChangeNotifierProvider<InvoiceProvider>(
          create: (context) => InvoiceProvider(),
        ),
        ChangeNotifierProvider<UserProvider>(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'ANDRÉ MENDELECK LTDA.',
        theme: ThemeData(
          primarySwatch: Colors.grey,
        ),
        home: const LoginScreen(),
        //home: const HomeScreen(),
        routes: AppRoutes.define(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
