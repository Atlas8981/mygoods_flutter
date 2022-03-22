import 'package:cached_network_image/cached_network_image.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mygoods_flutter/models/image.dart' as myImage;
import 'package:photo_view/photo_view.dart';

class BigImagePage extends StatelessWidget {
  const BigImagePage({
    Key? key,
    required this.image,
    required this.tag,
  }) : super(key: key);

  final myImage.Image image;
  final String tag;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Hero(
                  tag: tag,
                  child: ExtendedImage.network(
                    image.imageUrl,
                    mode: ExtendedImageMode.gesture,
                    enableMemoryCache: true,
                    scale: 0.1,
                    // imageProvider: CachedNetworkImageProvider(
                    //   image.imageUrl,
                    // ),
                    // minScale: 0.1,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 30,
              left: 5,
              child: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(
                  Icons.arrow_back,
                  size: 32,
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
