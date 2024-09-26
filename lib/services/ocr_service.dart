import 'dart:io';

import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';
import 'package:projeto_integrador_6/utils/preprocess_image.dart';

class OCRService {
  Future<String> extractTextFromImage(String imagePath) async {
    File processedImage = preprocessImage(imagePath);
    return await FlutterTesseractOcr.extractText(
      processedImage.path,
      language: "por",
      args: {
        "preserve_interword_spaces": "1",
      },
    );
  }
}
