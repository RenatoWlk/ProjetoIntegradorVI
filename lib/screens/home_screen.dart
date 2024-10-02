import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:provider/provider.dart';
import 'package:projeto_integrador_6/services/camera_service.dart';
import 'package:projeto_integrador_6/services/ocr_service.dart';
import 'package:projeto_integrador_6/widgets/camera_preview_widget.dart';
import 'package:projeto_integrador_6/providers/ocr_provider.dart';

class HomeScreen extends StatefulWidget {
  final CameraDescription camera;

  const HomeScreen({super.key, required this.camera});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<void> _initializeCameraFuture;

  @override
  void initState() {
    super.initState();
    final cameraService = Provider.of<CameraService>(context, listen: false);
    _initializeCameraFuture = cameraService.initialize(widget.camera);
  }

  @override
  Widget build(BuildContext context) {
    final cameraService = Provider.of<CameraService>(context);
    final ocrService = Provider.of<OCRService>(context);
    final ocrProvider = Provider.of<OCRProvider>(context);

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                _buildHeader(),
                const SizedBox(height: 30),
                _buildTitleText(),
                const SizedBox(height: 30),
                _buildCameraPreview(context, cameraService),
                const SizedBox(height: 30),
                _buildExtractedText(ocrProvider.extractedText),
                const SizedBox(height: 200)
              ],
            ),
          ),
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: _buildActionButtons(context, cameraService, ocrService, ocrProvider),
          ),
        ],
      ),
    );
  }

  // Header igual ao da outra página (com ícones de menu e perfil e o título centralizado)
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.menu, size: 40),
          onPressed: () {
            // Lógica para abrir o menu lateral
          },
        ),
        const Text(
          'Home',
          style: TextStyle(
            fontFamily: "Space Grotesk",
            fontSize: 28,
            fontWeight: FontWeight.w700,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.person_outline, size: 40),
          onPressed: () {
            // Lógica para abrir o perfil
          },
        ),
      ],
    );
  }

  Widget _buildTitleText() {
    return const Center(
      child: Text(
        'Escaneie sua nota fiscal \n para começar a registrar!',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: "Space Grotesk",
          fontSize: 28,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildCameraPreview(BuildContext context, CameraService cameraService) {
    return FutureBuilder<void>(
      future: _initializeCameraFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // Mantendo o tamanho da câmera grande (original)
          return SizedBox(
            height: 500, // Tamanho original maior da câmera
            width: MediaQuery.of(context).size.width * 0.9,
            child: const CameraPreviewWidget(),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _buildActionButtons(BuildContext context, CameraService cameraService, OCRService ocrService, OCRProvider ocrProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        // Botão de Lista de Compras
        FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('/list');
          },
          backgroundColor: Colors.white,
          child: const Icon(Icons.list_alt, size: 40),
        ),

        // Botão de Escanear
        FloatingActionButton(
          onPressed: () async {
            try {
              final image = await cameraService.captureImage();
              String text = await ocrService.extractTextFromImage(image.path);
              ocrProvider.updateExtractedText(text);
            } catch (e) {
              print('Erro capturando a imagem: $e');
            }
          },
          backgroundColor: Colors.orange,
          child: const Icon(Icons.document_scanner, size: 40),
        ),

        // Botão de Histórico
        FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('/history');
          },
          backgroundColor: Colors.white,
          child: const Icon(Icons.history, size: 40),
        ),
      ],
    );
  }

  Widget _buildExtractedText(String text) {
    return Text(
      'Texto detectado: $text',
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
