import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import 'package:projeto_integrador_6/models/invoice_item.dart';
import 'package:projeto_integrador_6/providers/ocr_provider.dart';
import 'package:projeto_integrador_6/providers/invoice_items_provider.dart';
import 'package:projeto_integrador_6/utils/invoice_items_util.dart';

Future<void> pickAndProccessPdf(BuildContext context, OCRProvider ocrProvider,
    InvoiceItemsProvider invoiceItemsProvider) async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['pdf'],
  );

  if (result != null && result.files.single.path != null) {
    String text = await extractTextFromPdf(result.files.single.path!);
    if (!context.mounted) return;
    await processPdfContent(context, text, ocrProvider, invoiceItemsProvider);
  }
}

Future<String> extractTextFromPdf(String path) async {
  final File file = File(path);
  final PdfDocument document =
      PdfDocument(inputBytes: await file.readAsBytes());
  String text = '';

  for (int i = 0; i < document.pages.count; i++) {
    final PdfTextExtractor extractor = PdfTextExtractor(document);
    text += extractor.extractText(startPageIndex: i);
  }

  document.dispose();
  return text;
}

Future<void> processPdfContent(BuildContext context, String text,
    OCRProvider ocrProvider, InvoiceItemsProvider invoiceItemsProvider) async {
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
          content: Text('Não foi possível identificar uma nota fiscal no PDF')),
    );
  }
}
