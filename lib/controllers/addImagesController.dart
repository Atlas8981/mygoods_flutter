

import 'package:get/get.dart';

class AddImageController extends GetxController{
  final rawImages = [].obs;

  void addImage(xfile){
    rawImages.add(xfile);
  }

}