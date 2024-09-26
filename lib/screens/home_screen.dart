import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:projeto_integrador_6/services/ocr_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.camera});
  final CameraDescription camera;

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  final OCRService _ocrService = OCRService();
  String extractedText = "";

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.ultraHigh,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  // BOTÃO DE MENU LATERAL
                  IconButton(
                    icon: const Icon(Icons.person_outline, size: 50),
                    iconSize: 50,
                    onPressed: () {
                      // TODO: Abrir o menu lateral
                    },
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // TEXTO DE TÍTULO
              const Center(
                child: Text(
                  'Escaneie sua nota fiscal \n para começar a registrar!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Space Grotesk",
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // PARTE QUE MOSTRA A CÂMERA
              FutureBuilder<void>(
                future: _initializeControllerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Center(
                      child: Container(
                        width: 390,
                        height: 550,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 4.0,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: CameraPreview(_controller),
                      ),
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),

              const SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  // BOTÃO LISTA DE COMPRAS
                  IconButton(
                    icon: const Icon(Icons.list_alt, size: 40),
                    iconSize: 40,
                    onPressed: () {
                      // TODO: botão que mostra a lista
                    },
                  ),

                  // BOTÃO ESCANEAR
                  FloatingActionButton(
                    onPressed: () async {
                      try {
                        await _initializeControllerFuture;
                        final image = await _controller.takePicture();
                        if (!context.mounted) return;

                        String text = await _ocrService.extractTextFromImage(image.path);
                        setState(() {
                          extractedText = text;
                        });
                      } catch (e) {
                        print(e);
                      }
                    },
                    backgroundColor: Colors.orange,
                    child: const Icon(Icons.document_scanner, size: 40),
                  ),

                  // BOTÃO HISTÓRICO DE COMPRAS
                  IconButton(
                    icon: const Icon(Icons.history, size: 40),
                    iconSize: 40,
                    onPressed: () {
                      // TODO: botão histórico de compras
                    },
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Exibir o texto extraído
              Text(
                'Texto detectado: $extractedText',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}