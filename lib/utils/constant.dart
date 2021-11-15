

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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