import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:image_picker/image_picker.dart';

import 'package:projeto_integrador_6/models/invoice_item.dart';
import 'package:projeto_integrador_6/providers/ocr_provider.dart';
import 'package:projeto_integrador_6/providers/invoice_items_provider.dart';
import 'package:projeto_integrador_6/services/ocr_service.dart';
import 'package:projeto_integrador_6/utils/dialogs/home_screen_dialogs.dart';
import 'package:projeto_integrador_6/utils/invoice_items_util.dart';
import 'package:projeto_integrador_6/utils/pdf_util.dart';
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
            _buildPdfButton(context, ocrProvider, invoiceItemsProvider),
            _buildUploadImageButton(
                context, ocrService, ocrProvider, invoiceItemsProvider),
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

  Widget _buildPdfButton(BuildContext context, OCRProvider ocrProvider,
      InvoiceItemsProvider invoiceItemsProvider) {
    return _buildButton(
      "Escanear PDF\nde NFC-e",
      Icons.picture_as_pdf,
      Colors.blue,
      () async {
        try {
          pickAndProccessPdf(context, ocrProvider, invoiceItemsProvider);
        } catch (e) {
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Erro ao processar o PDF.')),
          );
        }
      },
    );
  }

  Widget _buildUploadImageButton(BuildContext context, OCRService ocrService,
      OCRProvider ocrProvider, InvoiceItemsProvider invoiceItemsProvider) {
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

          if (!context.mounted) return;
          if (image != null) {
            await _processImage(context, image.path, ocrService, ocrProvider,
                invoiceItemsProvider);
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
    return _buildButton("Ajuda", Icons.help_outline, Colors.redAccent, () {
      showHelpDialog(context);
    });
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
    );
  }

  Future<void> _processImage(
      BuildContext context,
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
}
