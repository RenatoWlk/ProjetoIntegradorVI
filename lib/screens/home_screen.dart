import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'dart:io';

import 'package:projeto_integrador_6/models/invoice_item.dart';
import 'package:projeto_integrador_6/providers/ocr_provider.dart';
import 'package:projeto_integrador_6/providers/invoice_items_provider.dart';
import 'package:projeto_integrador_6/services/ocr_service.dart';
import 'package:projeto_integrador_6/utils/invoice_items_util.dart';
import 'package:projeto_integrador_6/widgets/custom_drawer.dart';
import 'package:projeto_integrador_6/widgets/custom_drawer_button.dart';
import 'package:projeto_integrador_6/widgets/custom_action_buttons.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ImagePicker _imagePicker = ImagePicker();

  Future<String> _extractTextFromPdf(String path) async {
    final File file = File(path);
    final PdfDocument document =
        PdfDocument(inputBytes: await file.readAsBytes());
    String text = '';

    // Extract text from all pages
    for (int i = 0; i < document.pages.count; i++) {
      final PdfTextExtractor extractor = PdfTextExtractor(document);
      text += extractor.extractText(startPageIndex: i);
    }

    document.dispose();
    return text;
  }

  Future<void> _processPdfContent(String text, OCRProvider ocrProvider,
      InvoiceItemsProvider invoiceItemsProvider) async {
    bool isInvoice = InvoiceItemsUtil.isInvoice(text);
    if (isInvoice) {
      final InvoiceItemsUtil invoiceItemsUtil = InvoiceItemsUtil();
      List<InvoiceItem> items =
          invoiceItemsUtil.extractInvoiceItemsFromText(text);
      invoiceItemsProvider.addInvoiceItems(items);
      ocrProvider
          .updateExtractedText(invoiceItemsUtil.invoiceItemsToString(items));

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PDF processado com sucesso!')),
      );
      Future.delayed(const Duration(seconds: 1), () {
        if (context.mounted) {
          Navigator.of(context).pushReplacementNamed('/list');
        }
      });
    } else {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Não foi possível identificar uma nota fiscal no PDF')),
      );
    }
  }

  Future<void> _processImage(
      String imagePath,
      OCRService ocrService,
      OCRProvider ocrProvider,
      InvoiceItemsProvider invoiceItemsProvider) async {
    try {
      String text = await ocrService.extractTextFromImage(imagePath);
      bool isInvoice = InvoiceItemsUtil.isInvoice(text);
      if (isInvoice) {
        final InvoiceItemsUtil invoiceItemsUtil = InvoiceItemsUtil();
        List<InvoiceItem> items =
            invoiceItemsUtil.extractInvoiceItemsFromText(text);
        invoiceItemsProvider.addInvoiceItems(items);
        ocrProvider
            .updateExtractedText(invoiceItemsUtil.invoiceItemsToString(items));

        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Imagem processada com sucesso!')),
        );
        Future.delayed(const Duration(seconds: 1), () {
          if (context.mounted) {
            Navigator.of(context).pushReplacementNamed('/list');
          }
        });
      } else {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'Não foi possível identificar uma nota fiscal na imagem')),
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao processar a imagem.')),
      );
    }
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ajuda - Como usar o app'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text('1. Escanear Nota Fiscal',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Use a câmera para escanear sua nota fiscal diretamente.'),
                SizedBox(height: 10),
                Text('2. Escanear PDF de NFC-e',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Carregue um arquivo PDF de Nota Fiscal Eletrônica.'),
                SizedBox(height: 10),
                Text('3. Carregar Imagem de NFC-e',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(
                    'Selecione uma imagem da galeria contendo sua nota fiscal.'),
                SizedBox(height: 10),
                Text('4. Lista de Compras',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Visualize e gerencie seus itens escaneados.'),
                SizedBox(height: 10),
                Text('5. Histórico',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Acesse suas notas fiscais anteriores.'),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Fechar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ocrService = Provider.of<OCRService>(context);
    final ocrProvider = Provider.of<OCRProvider>(context);
    final invoiceItemsProvider = Provider.of<InvoiceItemsProvider>(context);

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
                  _buildPageView(
                      context, ocrService, ocrProvider, invoiceItemsProvider),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 50.0),
            child: _buildActionButtons(context),
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

  Widget _buildPageView(BuildContext context, OCRService ocrService,
      OCRProvider ocrProvider, InvoiceItemsProvider invoiceItemsProvider) {
    return SizedBox(
      height: 700,
      child: Center(
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 30,
          crossAxisSpacing: 30,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildScanButton(
                context, ocrService, ocrProvider, invoiceItemsProvider),
            _buildPdfButton(),
            _buildUploadImageButton(),
            _buildHelpButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(
      String label, IconData icon, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      onPressed: onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 65, color: Colors.white),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildScanButton(BuildContext context, OCRService ocrService,
      OCRProvider ocrProvider, InvoiceItemsProvider invoiceItemsProvider) {
    return _buildButton(
      "Escanear Nota Fiscal",
      Icons.receipt_long_outlined,
      Colors.orange,
      () async {
        try {
          List<String> pictures =
              await CunningDocumentScanner.getPictures() ?? [];
          if (pictures.isNotEmpty) {
            String text = await ocrService.extractTextFromImage(pictures.first);
            bool isInvoice = InvoiceItemsUtil.isInvoice(text);
            if (isInvoice) {
              final InvoiceItemsUtil invoiceItemsUtil = InvoiceItemsUtil();
              List<InvoiceItem> items =
                  invoiceItemsUtil.extractInvoiceItemsFromText(text);
              invoiceItemsProvider.addInvoiceItems(items);
              ocrProvider.updateExtractedText(
                  invoiceItemsUtil.invoiceItemsToString(items));
              if (!context.mounted) return;

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Escaneado com sucesso!')),
              );
              Future.delayed(const Duration(seconds: 1), () {
                if (context.mounted) {
                  Navigator.of(context).pushReplacementNamed('/list');
                }
              });
            } else {
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text(
                        'Não foi possível identificar uma nota fiscal :(')),
              );
            }
          }
        } catch (e) {
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Erro ao escanear a imagem.')),
          );
        }
      },
    );
  }

  Widget _buildPdfButton() {
    return _buildButton(
      "Escanear PDF\nde NFC-e",
      Icons.picture_as_pdf,
      Colors.blue,
      () async {
        try {
          FilePickerResult? result = await FilePicker.platform.pickFiles(
            type: FileType.custom,
            allowedExtensions: ['pdf'],
          );

          if (result != null && result.files.single.path != null) {
            String text = await _extractTextFromPdf(result.files.single.path!);

            final ocrProvider =
                Provider.of<OCRProvider>(context, listen: false);
            final invoiceItemsProvider =
                Provider.of<InvoiceItemsProvider>(context, listen: false);

            await _processPdfContent(text, ocrProvider, invoiceItemsProvider);
          }
        } catch (e) {
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Erro ao processar o PDF.')),
          );
        }
      },
    );
  }

  Widget _buildUploadImageButton() {
    return _buildButton(
      "Carregar Imagem\nde NFC-e",
      Icons.image_search_outlined,
      Colors.lightBlue,
      () async {
        try {
          final XFile? image = await _imagePicker.pickImage(
            source: ImageSource.gallery,
            imageQuality: 100,
          );

          if (image != null) {
            final ocrService = Provider.of<OCRService>(context, listen: false);
            final ocrProvider =
                Provider.of<OCRProvider>(context, listen: false);
            final invoiceItemsProvider =
                Provider.of<InvoiceItemsProvider>(context, listen: false);

            await _processImage(
                image.path, ocrService, ocrProvider, invoiceItemsProvider);
          }
        } catch (e) {
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Erro ao carregar a imagem.')),
          );
        }
      },
    );
  }

  Widget _buildHelpButton() {
    return _buildButton(
      "Ajuda",
      Icons.help_outline,
      Colors.redAccent,
      _showHelpDialog,
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return ActionButtons(
      onListPressed: () {
        Navigator.of(context).pushReplacementNamed('/list');
      },
      onScanPressed: () {},
      onHistoryPressed: () {
        Navigator.of(context).pushReplacementNamed('/history');
      },
      scanButtonColor: Colors.orange,
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
    );
  }
}
