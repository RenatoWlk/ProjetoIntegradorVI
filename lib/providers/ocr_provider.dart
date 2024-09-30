import 'package:flutter/material.dart';

class OCRProvider with ChangeNotifier {
  String _extractedText = "";

  String get extractedText => _extractedText;

  void updateExtractedText(String text) {
    _extractedText = text;
    notifyListeners();
  }
}