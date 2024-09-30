import 'dart:io';
import 'package:image/image.dart' as img;

File preprocessImage(String imagePath) {
  final originalImage = img.decodeImage(File(imagePath).readAsBytesSync())!;

  // Deixa em escala de cinza
  final grayscaleImage = img.grayscale(originalImage);

  // AUmenta o contraste
  final contrastImage = img.adjustColor(grayscaleImage, contrast: 2);

  // Tira o blur
  // final unblurredImage = img.gaussianBlur(contrastImage, radius: 0);

  // Deixa a imagem em preto e branco
  final bwImage = img.luminanceThreshold(contrastImage, outputColor: false);

  final processedImagePath = '$imagePath-processed.png';
  File(processedImagePath).writeAsBytesSync(img.encodePng(bwImage));

  return File(processedImagePath);
}

