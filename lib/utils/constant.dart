import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:mygoods_flutter/models/DualImage.dart';
import 'package:mygoods_flutter/models/additionalInfo.dart';
import 'package:mygoods_flutter/models/item/category.dart';
import 'package:mygoods_flutter/models/item/item.dart';
import 'package:mygoods_flutter/models/image.dart' as myImage;
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

const String imageDir = "assets/images/";
const String userCollection = "users";
const String itemCollection = "items";
const String additionalCollection = "additionInfo";
const String saveItemCollection = "saveItems";
const String recentViewItemCollection = "recentView";




final redColor = Color.fromARGB(255, 236, 0, 0);

const String dummyNetworkImage =
    "https://firebasestorage.googleapis.com/v0/b/mygoods-e042f.appspot.com/o/flutter%2F2021-10-31%2021%3A58%3A15.282499?alt=media&token=f492b829-e106-467e-b3f1-6c05122a0969";

String? validatePhoneNumber(String? value) {
  String pattern = r'^(?:[+0][1-9])?[0-9]{9,10}$';
  RegExp regExp = RegExp(pattern);

  if (value == null || value.isEmpty) {
    return 'Empty Field';
  } else if (!regExp.hasMatch("0" + value)) {
    return 'Incorrect Phone Format';
  }
  return null;
}

checkImageProvider(DualImage image) {
  if (image.isNetworkImage) {
    return CachedNetworkImageProvider(image.itemImage!.imageUrl);
  } else {
    return FileImage(File(image.imagePath!));
  }
}

String? processAdditionalInfo(AdditionalInfo additionalInfo) {
  String processedData = "";
  if (additionalInfo.car != null) {
    final Car tempCar = additionalInfo.car!;
    processedData = processedData +
        "\n\n" +
        "Car Brand : " +
        tempCar.brand +
        "\nCar Model : " +
        tempCar.model +
        "\nCar Type : " +
        tempCar.category +
        "\nCar Year : " +
        tempCar.year;
  }
  if (additionalInfo.phone != null) {
    final Phone tempPhone = additionalInfo.phone!;
    processedData = processedData +
        "\n\n" +
        "Phone Brand : " +
        tempPhone.phoneBrand +
        "\nPhone Model : " +
        tempPhone.phoneModel;
  }
  if (additionalInfo.motoType != null) {
    processedData = processedData + "\n\n${additionalInfo.motoType}";
  }
  if (additionalInfo.computerParts != null) {
    processedData = processedData + "\n\n${additionalInfo.computerParts}";
  }
  if (additionalInfo.bikeType != null) {
    processedData = processedData + "\n\n${additionalInfo.bikeType}";
  }
  return processedData;
}



Color getUserAvatarNameColor(types.User user) {
  final index = user.id.hashCode % colors.length;
  return colors[index];
}

String getUserName(types.User user) =>
    '${user.firstName ?? ''} ${user.lastName ?? ''}'.trim();

void showToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    fontSize: 18,
    backgroundColor: Colors.blue,
    textColor: Colors.white,
  );
}

void showSnackBar(String title, String message) {
  Get.snackbar(
    title,
    message,
  );
}
