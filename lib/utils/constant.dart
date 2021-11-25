import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mygoods_flutter/models/DualImage.dart';
import 'package:mygoods_flutter/models/additionalInfo.dart';
import 'package:mygoods_flutter/models/category.dart';

final String imageDir = "assets/images/";

final List<Category> mainCategories = [
  Category(name: "Electronic", image: "${imageDir}electronic.png"),
  Category(name: "Car & Vehicle", image: "${imageDir}car.png"),
  Category(name: "Furniture & Decors", image: "${imageDir}furniture.png"),
];

final List<Category> electronicSubCategories = [
  Category(name: "Phone", image: "${imageDir}phone.png"),
  Category(name: "Desktop", image: "${imageDir}electronic.png"),
  Category(name: "Laptop", image: "${imageDir}laptop.png"),
  Category(name: "Parts & Accessories", image: "${imageDir}accessory.png"),
  Category(name: "Other", image: "${imageDir}other.png"),
];

final List<Category> carSubCategories = [
  Category(name: "Cars", image: "${imageDir}car.png"),
  Category(name: "Motorbikes", image: "${imageDir}moto.png"),
  Category(name: "Bicycle", image: "${imageDir}bike.png"),
  Category(name: "Other", image: "${imageDir}other.png"),
];
final List<Category> furnitureSubCategories = [
  Category(name: "Table & Desk", image: "${imageDir}table.png"),
  Category(name: "Chair & Sofa", image: "${imageDir}sofa.png"),
  Category(name: "Household Item", image: "${imageDir}household.png"),
  Category(name: "Other", image: "${imageDir}other.png"),
];

final redColor = Color.fromARGB(255, 236, 0, 0);

final String dummyNetworkImage =
    "https://firebasestorage.googleapis.com/v0/b/mygoods-e042f.appspot.com/o/flutter%2F2021-10-31%2021%3A58%3A15.282499?alt=media&token=f492b829-e106-467e-b3f1-6c05122a0969";

String? validatePhoneNumber(String? value) {
  String pattern = r'^(?:[+0][1-9])?[0-9]{9,10}$';
  RegExp regExp = new RegExp(pattern);

  if (value == null || value.isEmpty) {
    return 'Empty Field';
  } else if (!regExp.hasMatch("0" + value)) {
    return 'Incorrect Phone Format';
  }
  return null;
}

checkImageProvider(DualImage image){
  if(image.isNetworkImage){
    return CachedNetworkImageProvider(image.itemImage!.imageUrl);
  }else{
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


final List<String> hasAdditionalInfoList = [
  electronicSubCategories[0].name,
  electronicSubCategories[3].name,
  carSubCategories[0].name,
  carSubCategories[1].name,
  carSubCategories[2].name,
];

void showToast(String message) {
  Fluttertoast.showToast(
    msg: "$message",
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    fontSize: 18,
    backgroundColor: Colors.blue,
    textColor: Colors.white,
  );
}
