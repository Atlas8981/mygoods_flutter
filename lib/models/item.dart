// To parse this JSON data, do
//
//     final item = itemFromJson(jsonString);

import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

import 'package:mygoods_flutter/models/image.dart';

Item itemFromJson(String str) => Item.fromJson(json.decode(str));

String itemToJson(Item data) => json.encode(data.toJson());

class Item {
  Item({
    required this.date,
    required this.subCategory,
    required this.images,
    required this.amount,
    required this.address,
    required this.description,
    required this.userid,
    required this.itemid,
    required this.viewers,
    required this.phone,
    required this.price,
    required this.name,
    required this.mainCategory,
    required this.views,
  });

  final Timestamp date;
  final String subCategory;
  final List<Image> images;
  final int amount;
  final String address;
  final String description;
  final String userid;
  final String itemid;
  final List<String> viewers;
  final String phone;
  final double price;
  final String name;
  final String mainCategory;
  final int views;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    date: json["date"],
    subCategory: json["subCategory"],
    images: List<Image>.from(json["images"].map((x) => Image.fromJson(x))),
    amount: json["amount"],
    address: json["address"],
    description: json["description"],
    userid: json["userid"],
    itemid: json["itemid"],
    viewers: List<String>.from(json["viewers"].map((x) => x)),
    phone: json["phone"],
    price: json["price"].toDouble(),
    name: json["name"],
    mainCategory: json["mainCategory"],
    views: json["views"],
  );

  Map<String, dynamic> toJson() => {
    "date": date,
    "subCategory": subCategory,
    "images": List<dynamic>.from(images.map((x) => x.toJson())),
    "amount": amount,
    "address": address,
    "description": description,
    "userid": userid,
    "itemid": itemid,
    "viewers": List<dynamic>.from(viewers.map((x) => x)),
    "phone": phone,
    "price": price,
    "name": name,
    "mainCategory": mainCategory,
    "views": views,
  };
}



