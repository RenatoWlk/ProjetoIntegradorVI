import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:projeto_integrador_6/models/invoice_item.dart';
import 'package:provider/provider.dart';

import 'package:projeto_integrador_6/providers/ocr_provider.dart';
import 'package:projeto_integrador_6/services/camera_service.dart';
import 'package:projeto_integrador_6/services/ocr_service.dart';
import 'package:projeto_integrador_6/widgets/camera_preview_widget.dart';
import 'package:projeto_integrador_6/widgets/custom_drawer_button.dart';
import 'package:projeto_integrador_6/widgets/custom_drawer.dart';
import 'package:projeto_integrador_6/widgets/custom_action_buttons.dart';
import 'package:projeto_integrador_6/utils/invoice_util.dart';

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
      endDrawer: _buildDrawer(context),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 100),
                  _buildHeader(),
                  const SizedBox(height: 40),
                  _buildCameraPreview(context, cameraService),
                  const SizedBox(height: 40),
                  _buildExtractedText(ocrProvider.extractedText),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 50.0),
            child: _buildActionButtons(context, cameraService, ocrService, ocrProvider),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        SizedBox(width: 20),
        Expanded(
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
        CustomDrawerButton(),
        SizedBox(width: 20),
      ],
    );
  }

  Widget _buildCameraPreview(BuildContext context, CameraService cameraService) {
    return FutureBuilder<void>(
      future: _initializeCameraFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
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
    return ActionButtons(
        onListPressed: () {
          Navigator.of(context).pushReplacementNamed('/list');
        },
        onScanPressed: () async {
          try {
            final InvoiceUtil invoiceUtil = InvoiceUtil();
            final image = await cameraService.captureImage();
            String text = await ocrService.extractTextFromImage(image.path);
            List<InvoiceItem> itens = invoiceUtil.extractInvoiceItemsFromText(text);
            ocrProvider.updateExtractedText(invoiceUtil.invoiceItemsToString(itens));
            // ocrProvider.updateExtractedText(text);
          } catch (e) {
            if (kDebugMode) {
              print('Erro capturando a imagem: $e');
            }
          }
        },
        onHistoryPressed: () {
          Navigator.of(context).pushReplacementNamed('/history');
        },
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

  Widget _buildDrawer(BuildContext context) {
    return CustomDrawer(
      onNewListTap: () {
        Navigator.of(context).pushReplacementNamed('/list');
      },
      onScanTap: () {
        Navigator.pop(context);
      },
      onHistoryTap: () {
        Navigator.of(context).pushReplacementNamed('/history');
      },
      onEditDataTap: () {
        // TODO: Edição de dados
        Navigator.pop(context);
      },
      onLogoutTap: () {
        // TODO: Logout
        Navigator.pop(context);
      },
    );
  }
}