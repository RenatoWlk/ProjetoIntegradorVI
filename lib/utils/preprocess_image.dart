import 'dart:io';
import 'package:image/image.dart' as img;

String preprocessImage(String imagePath) {
  final originalImage = img.decodeImage(File(imagePath).readAsBytesSync())!;

  // Deixa em escala de cinza
  // final grayscaleImage = img.grayscale(originalImage);

  // AUmenta o contraste
  final contrastImage = img.adjustColor(originalImage, contrast: 1.5);

  // Tira o blur
  // final unblurredImage = img.gaussianBlur(originalImage, radius: 0);

  // Deixa a imagem em preto e branco
  // final bwImage = img.luminanceThreshold(contrastImage, outputColor: false);

  final processedImagePath = '$imagePath-processed.png';
  File(processedImagePath).writeAsBytesSync(img.encodePng(contrastImage));

  return processedImagePath;
}
