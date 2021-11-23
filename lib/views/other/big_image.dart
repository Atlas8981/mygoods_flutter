

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mygoods_flutter/models/image.dart' as myImage;
import 'package:photo_view/photo_view.dart';


class BigImagePage extends StatefulWidget {
  const BigImagePage({
    Key? key,
    required this.image,
    // required this.isNetworkImage,
  }) : super(key: key);

  final myImage.Image image;
  // final bool isNetworkImage;

  @override
  _BigImagePageState createState() => _BigImagePageState();
}

class _BigImagePageState extends State<BigImagePage> {
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
              child: Container(
                child:ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Hero(
                    tag: widget.image.imageName,
                    child: PhotoView(
                      imageProvider: CachedNetworkImageProvider(widget.image.imageUrl),
                      minScale: 0.1,
                    ),
                  ),
                )
              ),
            ),
            Positioned(
              top: 30,
              left: 5,
              child: IconButton(
                  onPressed: (){
                    Get.back();
                  },
                  icon: Icon(Icons.arrow_back,size: 32,)
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ImageProvider decideTypeOfImage() {
  //   if (widget.isNetworkImage) {
  //     return NetworkImage(widget.image);
  //   }else{
  //     return FileImage(
  //       File(widget.image),
  //       // width: 80,
  //       // height: 80,
  //       // fit: BoxFit.cover,
  //     );
  //   }
  //
  // }
}