import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:projeto_integrador_6/providers/invoice_provider.dart';
import 'package:projeto_integrador_6/providers/invoice_items_provider.dart';
import 'package:projeto_integrador_6/providers/ocr_provider.dart';
import 'package:projeto_integrador_6/providers/theme_provider.dart';
import 'package:projeto_integrador_6/providers/user_provider.dart';
import 'package:projeto_integrador_6/screens/login_screen.dart';
import 'package:projeto_integrador_6/services/database/database.dart';
import 'package:projeto_integrador_6/services/ocr_service.dart';
import 'package:projeto_integrador_6/routes/app_routes.dart';

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
          create: (_) => InvoiceItemsProvider(),
        ),
        ChangeNotifierProvider<InvoiceProvider>(
          create: (_) => InvoiceProvider(),
        ),
        ChangeNotifierProvider<UserProvider>(
          create: (_) => UserProvider(),
        ),
        ChangeNotifierProvider<ThemeProvider>(
          create: (_) => ThemeProvider(),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'ANDRÉ MENDELECK LTDA.',
            theme: ThemeData(
              fontFamily: "Space Grotesk",
              primarySwatch: Colors.orange,
            ),
            darkTheme: ThemeData(
              fontFamily: "Space Grotesk",
              brightness: Brightness.dark,
            ),
            themeMode: themeProvider.themeMode,
            home: const LoginScreen(),
            routes: AppRoutes.define(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
