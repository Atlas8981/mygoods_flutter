

import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddImageController extends GetxController{
  final RxList rawImages = [].obs;

  void addImage(XFile xfile){
    rawImages.add(xfile);
  }

  List<File> getRawImageInFile(){
    List<File> files = [];
    for (int i = 0; i < rawImages.length; i++) {
      files.add(File(rawImages[0].path));
    }
    return files;
  }
}