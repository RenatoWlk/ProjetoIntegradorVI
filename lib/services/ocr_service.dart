import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart'; // OCR

class OCRService {
  // Função para realizar OCR com o Google ML Kit
  Future<String> extractTextFromImage(String imagePath) async {
    final inputImage = InputImage.fromFilePath(imagePath);
    final textRecognizer = TextRecognizer();

    try {
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
      String extractedText = recognizedText.text;

      return extractedText;
    } catch (e) {
        print("Erro ao realizar OCR: $e");
        return "Erro ao realizar OCR";
    } finally {
      // Fecha o textRecognizer para liberar recursos
      textRecognizer.close();
    }
  }
}

