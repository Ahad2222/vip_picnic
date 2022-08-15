import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:vip_picnic/constant/color.dart';
import 'package:vip_picnic/generated/assets.dart';

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
        child: Image.network(
          imageUrl!,
          fit: BoxFit.cover,
          width: Get.width,
          height: Get.height,
        ),
      ),
    );
  }
}