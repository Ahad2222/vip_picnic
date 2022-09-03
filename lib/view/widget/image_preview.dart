
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImagePreview extends StatelessWidget {
  ImagePreview({
    this.imageUrl,
  });

  String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'chatMedia',
      transitionOnUserGestures: true,
      child: InteractiveViewer(
        scaleEnabled: true,
        panEnabled: true,
        child: Image.network(
          imageUrl!,
          scale: 0.7,
          fit: BoxFit.contain,
          width: Get.width,
          height: Get.height,
        ),
      ),
    );
  }
}
