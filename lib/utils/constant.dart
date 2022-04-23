import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:khmer_date/khmer_date.dart';
import 'package:mygoods_flutter/models/DualImage.dart';
import 'package:mygoods_flutter/models/additionalInfo.dart';
import 'package:mygoods_flutter/models/category.dart';
import 'package:mygoods_flutter/models/item.dart';
import 'package:mygoods_flutter/models/image.dart' as myImage;
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

const String imageDir = "assets/images/";
const String userCollection = "users";
const String itemCollection = "items";
const String additionalCollection = "additionInfo";
const String saveItemCollection = "saveItems";
const String recentViewItemCollection = "recentView";

final dummyItemList = [
  Item(
      date: Timestamp.now(),
      subCategory: "subCategory",
      images: [
        myImage.Image(
          imageName: "imageName",
          imageUrl: dummyNetworkImage,
        )
      ],
      amount: 0,
      address: "address",
      description: "description",
      userid: "userid",
      itemid: "itemid",
      viewers: [],
      phone: "phone",
      price: 123,
      name: "name",
      mainCategory: "mainCategory",
      views: 0),
  Item(
      date: Timestamp.now(),
      subCategory: "subCategory",
      images: [
        myImage.Image(imageName: "imageName", imageUrl: dummyNetworkImage)
      ],
      amount: 0,
      address: "address",
      description: "description",
      userid: "userid",
      itemid: "itemid",
      viewers: [],
      phone: "phone",
      price: 123,
      name: "name",
      mainCategory: "mainCategory",
      views: 0),
  Item(
      date: Timestamp.now(),
      subCategory: "subCategory",
      images: [
        myImage.Image(imageName: "imageName", imageUrl: dummyNetworkImage)
      ],
      amount: 0,
      address: "address",
      description: "description",
      userid: "userid",
      itemid: "itemid",
      viewers: [],
      phone: "phone",
      price: 123,
      name: "name",
      mainCategory: "mainCategory",
      views: 0),
  Item(
      date: Timestamp.now(),
      subCategory: "subCategory",
      images: [
        myImage.Image(imageName: "imageName", imageUrl: dummyNetworkImage)
      ],
      amount: 0,
      address: "address",
      description: "description",
      userid: "userid",
      itemid: "itemid",
      viewers: [],
      phone: "phone",
      price: 123,
      name: "name",
      mainCategory: "mainCategory",
      views: 0),
  Item(
      date: Timestamp.now(),
      subCategory: "subCategory",
      images: [
        myImage.Image(imageName: "imageName", imageUrl: dummyNetworkImage)
      ],
      amount: 0,
      address: "address",
      description: "description",
      userid: "userid",
      itemid: "itemid",
      viewers: [],
      phone: "phone",
      price: 123,
      name: "name",
      mainCategory: "mainCategory",
      views: 0),
  Item(
      date: Timestamp.now(),
      subCategory: "subCategory",
      images: [
        myImage.Image(imageName: "imageName", imageUrl: dummyNetworkImage)
      ],
      amount: 0,
      address: "address",
      description: "description",
      userid: "userid",
      itemid: "itemid",
      viewers: [],
      phone: "phone",
      price: 123,
      name: "name",
      mainCategory: "mainCategory",
      views: 0),
  Item(
      date: Timestamp.now(),
      subCategory: "subCategory",
      images: [
        myImage.Image(imageName: "imageName", imageUrl: dummyNetworkImage)
      ],
      amount: 0,
      address: "address",
      description: "description",
      userid: "userid",
      itemid: "itemid",
      viewers: [],
      phone: "phone",
      price: 123,
      name: "name",
      mainCategory: "mainCategory",
      views: 0),
  Item(
      date: Timestamp.now(),
      subCategory: "subCategory",
      images: [
        myImage.Image(
          imageName: "imageName",
          imageUrl: dummyNetworkImage,
        )
      ],
      amount: 0,
      address: "address",
      description: "description",
      userid: "userid",
      itemid: "itemid",
      viewers: [],
      phone: "phone",
      price: 123,
      name: "name",
      mainCategory: "mainCategory",
      views: 0),
];

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

const redColor = Color.fromARGB(255, 236, 0, 0);
const defaultColor = Color(0xFF34568B);
const englishFontFamily = 'Roboto';
const khmerFontFamily = 'KhmerOSBattambang';

const String dummyNetworkImage =
    "https://firebasestorage.googleapis.com/v0/b/mygoods-e042f.appspot.com/o/flutter%2F2021-10-31%2021%3A58%3A15.282499?alt=media&token=f492b829-e106-467e-b3f1-6c05122a0969";
const String networkBackgroundImage =
    "https://firebasestorage.googleapis.com/v0/b/project-shotgun.appspot.com/o/IMG_2086-EFFECTS.jpg?alt=media&token=fcd87303-09e6-4ec7-9620-211f240fc85f";

Widget adaptiveHeightSpacing({double? height}) {
  if (Get.locale == const Locale('en', 'US')) {
    return SizedBox(height: height ?? 8);
  }
  return SizedBox(height: (height != null && height > 8) ? height - 8 : 0);
}

Widget commonHeightSpacing({double? height}) {
  return SizedBox(height: height ?? 8);
}

Widget commonWidthSpacing({double? width}) {
  return SizedBox(width: width ?? 8);
}

String? validatePhoneNumber(String? value) {
  String pattern = r'^(?:[+0][1-9])?[0-9]{9,10}$';
  RegExp regExp = RegExp(pattern);

  if (value == null || value.isEmpty) {
    return 'emptyField'.tr;
  } else if (!regExp.hasMatch("0" + value)) {
    return 'invalidPhoneNumber'.tr;
  }
  return null;
}

String getFont() {
  if (Get.locale == const Locale('en', 'US')) {
    return englishFontFamily;
  } else {
    return khmerFontFamily;
  }
}

String calDate(Timestamp itemDate) {
//Convert to second
  double date = (Timestamp.now().seconds - itemDate.seconds).toDouble();
  String timeEnd = "second";
  if (date > 0) {
    if (date >= 60) {
      date = date / 60;
      timeEnd = "minutes";
      if (date >= 60) {
        date = date / 60;
        timeEnd = "hours";
        if (date >= 24) {
          date = date / 24;
          timeEnd = "day";
          if (date > 7) {
            date = date / 7;
            timeEnd = "week";
            if (date > 4) {
              date = date / 4;
              timeEnd = "month";
// if(date>12){
//   date = date/12.roundToDouble();
//   timeEnd = " year(s)";
// }
            }
          }
        }
      }
    }
  }
  return "${date.toInt()} ${timeEnd.tr}";
}

final priceNumberFormat = NumberFormat("###,###.0#");

String formatPrice(double price) {
  return priceNumberFormat.format(price.toInt());
}

String formatLocaleNumber(String number) {
  if (Get.locale == const Locale('en', 'US')) {
    return number;
  }
  return KhmerDate.khmerNumber(number);
}

String formatDate(int millisecond) {
  final dateTime = DateTime.fromMillisecondsSinceEpoch(millisecond);
  final chatDateFormat = DateFormat('E MM, hh:mm', getLanguageCode());
  return chatDateFormat.format(dateTime);
}

String getLanguageCode() {
  if (Get.locale == const Locale('en', 'US')) {
    return "en";
  } else {
    return 'km';
  }
}

checkImageProvider(DualImage image) {
  if (image.isNetworkImage) {
    return NetworkImage(
      image.itemImage!.imageUrl,
    );
  } else {
    return FileImage(File(image.imagePath!));
  }
}

ThemeMode determineThemeMode(String? selectedMode) {
  if (selectedMode == "Light") {
    return ThemeMode.light;
  } else if (selectedMode == "Dark") {
    return ThemeMode.dark;
  } else {
    return ThemeMode.system;
  }
}

String? processAdditionalInfo(AdditionalInfo additionalInfo) {
  String processedData = "";
  if (additionalInfo.car != null) {
    final Car tempCar = additionalInfo.car!;
    processedData = processedData +
        "\n" +
        "${"carBrand".tr} : " +
        tempCar.brand +
        "\n${"carModel".tr} : " +
        tempCar.model +
        "\n${"carType".tr} : " +
        tempCar.category +
        "\n${"carYear".tr} : " +
        tempCar.year;
  }
  if (additionalInfo.phone != null) {
    final Phone tempPhone = additionalInfo.phone!;
    processedData = processedData +
        "\n" +
        "${"phoneBrand".tr} : " +
        tempPhone.phoneBrand +
        "\n${"phoneModel".tr} : " +
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

Color getUserAvatarNameColor(types.User user) {
  final index = user.id.hashCode % colors.length;
  return colors[index];
}

String getUserName(types.User user) =>
    '${user.firstName ?? ''} ${user.lastName ?? ''}'.trim();

void requestFocus(BuildContext context) {
  return FocusScope.of(context).requestFocus(FocusNode());
}

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
