import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';

class OCRService {
  Future<String> extractTextFromImage(String imagePath) async {
    return await FlutterTesseractOcr.extractText(imagePath);
  }
}