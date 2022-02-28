
import 'package:mygoods_flutter/models/my_image.dart';

class DualImage {
  DualImage(this.isNetworkImage, {this.imagePath, this.itemImage});

  bool isNetworkImage;
  String? imagePath;
  MyImage? itemImage;

  @override
  String toString() {
    return 'DualImage{isNetworkImage: $isNetworkImage, imagePath: $imagePath, itemImage: $itemImage}';
  }
}
