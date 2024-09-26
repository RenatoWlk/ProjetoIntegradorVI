import 'dart:io';
import 'package:image/image.dart' as img;

File preprocessImage(String imagePath) {
  final originalImage = img.decodeImage(File(imagePath).readAsBytesSync())!;
  final grayscaleImage = img.grayscale(originalImage);
  final contrastImage = img.adjustColor(grayscaleImage, contrast: 1.5);
  final processedImagePath = '$imagePath-processed.png';
  File(processedImagePath).writeAsBytesSync(img.encodePng(contrastImage));
  return File(processedImagePath);
}
