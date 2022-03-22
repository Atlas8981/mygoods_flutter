import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImageViewer extends StatefulWidget {
  const ImageViewer({
    Key? key,
    required this.file,
  }) : super(key: key);
  final File file;

  @override
  State<ImageViewer> createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Preview Image"),
        actions: [
          IconButton(
            onPressed: () {
              Get.back(result: true);
            },
            icon: Icon(Icons.check),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black,
        child: ExtendedImage.file(
          widget.file,
          mode: ExtendedImageMode.gesture,
          width: 100,
          height: 100,
        ),
      ),
    );
  }
}
