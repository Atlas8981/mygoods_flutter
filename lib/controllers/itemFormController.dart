
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mygoods_flutter/models/item.dart';

class ItemFormController extends GetxController{
  // final itemName = "".obs;

  // final address= "".obs;
  // final description="".obs;
  // final phone = "".obs;
  // final price = 0.obs;
  final subCat = "".obs;
  final mainCat = "".obs;
  final condition = "".obs;
  final RxList rawImages = [].obs;
  final TextEditingController nameCon = TextEditingController(),
      priceCon = TextEditingController(),
      addressCon = TextEditingController(),
      phoneCon = TextEditingController(),
      descriptionCon = TextEditingController(),
      categoryCon = TextEditingController(),
      additionalInfoCon = TextEditingController(),
      conditionCon = TextEditingController();

  // Item item = Item(
  //     date: date,
  //     subCategory: subCategory,
  //     images: images,
  //     amount: amount,
  //     address: address,
  //     description: description,
  //     userid: userid,
  //     itemid: itemid,
  //     viewers: viewers,
  //     phone: phone,
  //     price: price,
  //     name: name,
  //     mainCategory: mainCategory,
  //     views: views)
  void clearData() {
    subCat.value = "";
    mainCat.value = "";
    categoryCon.text = "";
    addressCon.text = "";
    descriptionCon.text = "";
    phoneCon.text = "";
    priceCon.text = "";
    nameCon.text = "";
    conditionCon.text = "";
    condition.value = "";
    rawImages.clear();
    // setState(() {
    //   formKey = GlobalKey<FormState>();
    // });
  }
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

  void clear() {
    rawImages.value = [];
  }

}