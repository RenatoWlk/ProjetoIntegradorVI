import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraService with ChangeNotifier {
  late CameraController _controller;

  CameraController get controller => _controller;
  bool get isInitialized => _controller.value.isInitialized;

  Future<void> initialize(CameraDescription camera) async {
    _controller = CameraController(camera, ResolutionPreset.max);
    await _controller.initialize();
  }

  @override
  void dispose() {
    if (_controller.value.isInitialized) {
      _controller.dispose();
    }
    super.dispose();
  }

  Future<XFile> captureImage() async {
    return await _controller.takePicture();
  }

  Future<void> disableFlash() async {
    if (_controller.value.isInitialized && !_controller.value.isTakingPicture) {
      if (_controller.value.flashMode != FlashMode.off) {
        await _controller.setFlashMode(FlashMode.off);
        notifyListeners();
      }
    }
  }

  Future<void> toggleFlash() async {
    if (_controller.value.flashMode == FlashMode.off) {
      await _controller.setFlashMode(FlashMode.torch);
      notifyListeners();
    } else {
      await _controller.setFlashMode(FlashMode.off);
      notifyListeners();
    }
  }

  bool get isFlashOn => _controller.value.flashMode == FlashMode.torch;
}
