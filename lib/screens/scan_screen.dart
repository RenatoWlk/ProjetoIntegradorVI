import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class ScanInvoiceScreen extends StatefulWidget {
  const ScanInvoiceScreen({super.key});

  @override
  _ScanInvoiceScreenState createState() => _ScanInvoiceScreenState();
}

class _ScanInvoiceScreenState extends State<ScanInvoiceScreen> {
  File? _image;
  String _scannedText = "";
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImageFromCamera() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      _performOCR();
    }
  }

  Future<void> _pickImageFromGallery() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      _performOCR();
    }
  }

  Future<void> _performOCR() async {
    if (_image == null) return;

    final textRecognizer = TextRecognizer();
    final inputImage = InputImage.fromFile(_image!);
    final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

    setState(() {
      _scannedText = recognizedText.text;
    });

    textRecognizer.close();

    print(_scannedText);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escanear Nota Fiscal'),
      ),
      body: SingleChildScrollView(
        child: Center( // Isso vai centralizar os widgets na tela
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 20),
              _image != null
                  ? Image.file(_image!)
                  : const Text('Nenhuma imagem selecionada.'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickImageFromCamera,
                child: const Text('Tirar Foto'),
              ),
              ElevatedButton(
                onPressed: _pickImageFromGallery,
                child: const Text('Escolher da Galeria'),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _scannedText.isEmpty ? 'Nenhum texto escaneado.' : _scannedText,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
