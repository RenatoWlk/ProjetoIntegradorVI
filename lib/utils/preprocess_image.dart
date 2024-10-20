import 'dart:io';
import 'package:image/image.dart' as img;

String preprocessImage(String imagePath) {
  img.Image image = img.decodeImage(File(imagePath).readAsBytesSync())!;
  image =
      img.copyResize(image, width: image.width * 2, height: image.height * 2);
  // image = img.gaussianBlur(image, radius: 0);
  image = img.grayscale(image);
  image = img.adjustColor(image, contrast: 2, brightness: 0.75);
  // image = img.luminanceThreshold(image, outputColor: false);
  final processedImagePath = '$imagePath-processed.png';
  File(processedImagePath).writeAsBytesSync(img.encodePng(image));

  return processedImagePath;
}
