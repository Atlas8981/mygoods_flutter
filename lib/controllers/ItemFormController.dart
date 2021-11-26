import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mygoods_flutter/models/DualImage.dart';
import 'package:mygoods_flutter/models/additionalInfo.dart';
import 'package:mygoods_flutter/services/item_database_service.dart';
import 'package:mygoods_flutter/utils/constant.dart';

class ItemFormController extends GetxController {
  final itemService = ItemDatabaseService();
  GlobalKey formKey = GlobalKey<FormState>();
  final isVisible = false.obs;
  final subCat = "".obs;
  final mainCat = "".obs;
  final condition = "".obs;
  final RxList tempImages = [].obs;
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
    tempImages.clear();
    formKey = new GlobalKey<FormState>();
    update();
  }

  void addImage(DualImage dualImage) {
    tempImages.add(dualImage);
  }

  List<File> getRawImageInFile() {
    final List<File> files = [];

    for (int i = 0; i < tempImages.length; i++) {
      final DualImage tempDualImage = tempImages[0];
      if (!tempDualImage.isNetworkImage) {
        files.add(File(tempDualImage.imagePath!));
      }
    }
    return files;
  }

  void getAdditionalInfo(String itemId, String subCat) {
    itemService.getAdditionalInfo(itemId: itemId, subCat: subCat).then((value) {
      if (value == null) {
        return;
      }
      final AdditionalInfo additionalInfo =
          additionalInfoFromFirestore(value.data()!);

      conditionCon.text = "${additionalInfo.condition}";
      additionalInfoCon.text = getAdditionInfo(additionalInfo);
    });
  }

  String getAdditionInfo(AdditionalInfo additionalInfo) {
    if (additionalInfo.car != null) {
      final Car tempCar = additionalInfo.car!;
      return "${tempCar.brand}, ${tempCar.model}, ${tempCar.category}, ${tempCar.year}";
    }
    if (additionalInfo.phone != null) {
      final Phone tempPhone = additionalInfo.phone!;
      return "${tempPhone.phoneBrand}, ${tempPhone.phoneModel}";
    }
    if (additionalInfo.motoType != null) {
      return "${additionalInfo.motoType}";
    }
    if (additionalInfo.computerParts != null) {
      return "${additionalInfo.computerParts}";
    }
    if (additionalInfo.bikeType != null) {
      return "${additionalInfo.bikeType}";
    }
    return "";
  }

  void changeProgressBarVisibility(){
    isVisible.value = !isVisible.value;
    update();
  }
}
