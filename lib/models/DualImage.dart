
import 'package:mygoods_flutter/models/image.dart';

class DualImage {
  DualImage(this.isNetworkImage, {this.imagePath, this.itemImage});

  bool isNetworkImage;
  String? imagePath;
  Image? itemImage;

  @override
  String toString() {
    return 'DualImage{isNetworkImage: $isNetworkImage, imagePath: $imagePath, itemImage: $itemImage}';
  }
}
