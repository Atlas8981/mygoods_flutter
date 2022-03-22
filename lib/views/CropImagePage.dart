import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CropImagePage extends StatefulWidget {
  const CropImagePage({
    Key? key,
    required this.image,
  }) : super(key: key);
  final XFile image;

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
        title: Text("Crop Image"),
        actions: [
          IconButton(
            onPressed: () {
              final rect = editorKey.currentState?.getCropRect();
              print("rect: $rect" );
            },
            icon: Icon(Icons.check),
          ),
          IconButton(
            onPressed: () {
              editorKey.currentState?.reset();
            },
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
      body: ExtendedImage.file(
        File(widget.image.path),
        fit: BoxFit.contain,
        mode: ExtendedImageMode.editor,
        extendedImageEditorKey: editorKey,
        initEditorConfigHandler: (state) {
          return EditorConfig(
            maxScale: 8.0,
            cropRectPadding: EdgeInsets.all(20.0),
            hitTestSize: 20.0,
            cropAspectRatio: 1.0,
          );
        },

      ),
    );
  }
}
