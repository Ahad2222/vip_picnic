import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vip_picnic/constant/color.dart';
import 'package:vip_picnic/generated/assets.dart';
import 'package:vip_picnic/view/widget/loading.dart';

class PostImagePreview extends StatelessWidget {
  PostImagePreview({
    required this.imageUrl,
  });

  String imageUrl = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Expanded(
            child: InteractiveViewer(
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                height: Get.height,
                width: Get.width,
                errorBuilder: (
                  BuildContext context,
                  Object exception,
                  StackTrace? stackTrace,
                ) {
                  return const Text(' ');
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  } else {
                    return loading();
                  }
                },
              ),
            ),
          ),
          Positioned(
            top: 50,
            left: 15,
            child: IconButton(
              onPressed: () => Get.back(),
              icon: Image.asset(
                Assets.imagesArrowBack,
                height: 22.04,
                color: kTertiaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
