import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:projeto_integrador_6/services/camera_service.dart';
import 'package:provider/provider.dart';

class CameraPreviewWidget extends StatelessWidget {
  const CameraPreviewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cameraService = Provider.of<CameraService>(context);

    return Center(
        child: Container(
            width: 500,
            height: 680,
            decoration: BoxDecoration(
              border: Border.all(width: 4.0),
              borderRadius: BorderRadius.circular(15),
            ),
            child: CameraPreview(
              cameraService.controller,
              child: Positioned(
                  top: 20,
                  right: 20,
                  child: Consumer<CameraService>(
                      builder: (context, cameraService, child) {
                    return IconButton(
                        icon: Icon(
                          cameraService.isFlashOn
                              ? Icons.flash_on
                              : Icons.flash_off,
                          size: 40,
                          color: Colors.white,
                        ),
                        onPressed: () async {
                          await cameraService.toggleFlash();
                        });
                  })),
            )));
  }
}
