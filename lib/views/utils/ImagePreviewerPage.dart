import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImagePreviewerPage extends StatefulWidget {
  const ImagePreviewerPage({
    Key? key,
    required this.image,
  }) : super(key: key);
  final dynamic image;

  @override
  State<ImagePreviewerPage> createState() => _ImagePreviewerPageState();
}

class _ImagePreviewerPageState extends State<ImagePreviewerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Preview Image"),
        actions: [
          IconButton(
            onPressed: () {
              Get.back(result: true);
            },
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black,
        child: (widget.image is File)
            ? ExtendedImage.file(
                widget.image,
                mode: ExtendedImageMode.gesture,
                scale: 0.1,
              )
            : ExtendedImage.network(
                widget.image,
                mode: ExtendedImageMode.gesture,
                scale: 0.1,
              ),
      ),
    );
  }
}
