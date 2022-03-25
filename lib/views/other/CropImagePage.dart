import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CropImagePage extends StatefulWidget {
  const CropImagePage({
    Key? key,
    required this.userImage,
  }) : super(key: key);
  final XFile userImage;

  @override
  State<CropImagePage> createState() => _CropImagePageState();
}

class _CropImagePageState extends State<CropImagePage> {
  final GlobalKey<ExtendedImageEditorState> editorKey =
      GlobalKey<ExtendedImageEditorState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Crop Image"),
        actions: [
          IconButton(
            onPressed: () async {
              final Rect? rect = editorKey.currentState?.getCropRect();
              if (rect != null) {
                final File cropImage = await FlutterNativeImage.cropImage(
                  widget.userImage.path,
                  rect.left.toInt(),
                  rect.top.toInt(),
                  rect.width.toInt(),
                  rect.height.toInt(),
                );
                Get.back(result: cropImage);
              }
            },
            icon: const Icon(Icons.check),
          ),
          IconButton(
            onPressed: () {
              editorKey.currentState?.reset();
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SafeArea(
        child: ExtendedImage.file(
          File(widget.userImage.path),
          fit: BoxFit.contain,
          mode: ExtendedImageMode.editor,
          extendedImageEditorKey: editorKey,
          initEditorConfigHandler: (state) {
            return EditorConfig(
              maxScale: 8.0,
              cropRectPadding: const EdgeInsets.all(20.0),
              hitTestSize: 20.0,
              cropAspectRatio: 1.0,
            );
          },
        ),
      ),
    );
  }
}
