

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddImageController extends GetxController{
  final RxList rawImages = [].obs;

  void addImage(XFile xfile){
    rawImages.add(xfile);
  }

}