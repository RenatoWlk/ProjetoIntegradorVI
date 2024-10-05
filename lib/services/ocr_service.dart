import 'package:flutter/foundation.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart'; // OCR

class OCRService {
  Future<String> extractTextFromImage(String imagePath) async {
    final inputImage = InputImage.fromFilePath(imagePath);
    final textRecognizer = TextRecognizer();

    try {
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
      String extractedText = recognizedText.text;

      return extractedText;
    } catch (e) {
        if (kDebugMode) {
          print("Erro ao realizar OCR: $e");
        }
        return "Erro ao realizar OCR";
    } finally {
      textRecognizer.close();
    }
  }
}