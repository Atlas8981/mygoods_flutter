import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class ImageViewerPage extends StatelessWidget {
  const ImageViewerPage({
    Key? key,
    required this.image,
    required this.tag,
  }) : super(key: key);

  final dynamic image;
  final String tag;

  @override
  Widget build(BuildContext context) {
    return ExtendedImageSlidePage(
      slideAxis: SlideAxis.both,
      slideType: SlideType.onlyImage,
      resetPageDuration: const Duration(milliseconds: 100),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          elevation: 0,
        ),
        body: Container(
          color: Colors.black,
          width: double.infinity,
          height: double.infinity,
          child: ExtendedImageSlidePageHandler(
            child: Hero(
              tag: tag,
              child: (image is File)
                  ? ExtendedImage.file(
                      image,
                      mode: ExtendedImageMode.gesture,
                      scale: 0.1,
                      enableMemoryCache: true,
                      cacheRawData: true,
                      enableSlideOutPage: true,
                    )
                  : ExtendedImage.network(
                      image,
                      mode: ExtendedImageMode.gesture,
                      scale: 0.1,
                      enableMemoryCache: true,
                      cache: true,
                      enableSlideOutPage: true,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
