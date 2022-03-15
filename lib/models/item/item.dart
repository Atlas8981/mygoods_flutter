import 'dart:convert';

import 'package:mygoods_flutter/models/item/category.dart';

import '../image.dart';

List<Item> itemResponseFromMap(String str) =>
    List<Item>.from(
        json.decode(str).map((x) => Item.fromMap(x)));

String itemResponseToMap(List<Item> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class Item {
  Item({
    required this.itemid,
    required this.name,
    required this.address,
    required this.category,
    required this.description,
    required this.userid,
    required this.phone,
    required this.images,
    required this.amount,
    required this.price,
    required this.viewers,
    required this.views,
    required this.date,
  });

  int itemid;
  String name;
  String address;
  Category category;
  String description;
  String userid;
  String phone;
  List<Image> images;
  int amount;
  double price;
  List<String> viewers;
  int views;
  DateTime date;

  factory Item.fromMap(Map<String, dynamic> json) =>
      Item(
        itemid: json["itemid"],
        name: json["name"],
        address: json["address"],
        category: Category.fromMap(json["category"]),
        description: json["description"],
        userid: json["userid"],
        phone: json["phone"],
        images: List<Image>.from(json["images"].map((x) => Image.fromMap(x))),
        amount: json["amount"],
        price: json["price"],
        viewers: List<String>.from(json["viewers"].map((x) => x)),
        views: json["views"],
        date: DateTime.parse(json["date"]),
      );

  Map<String, dynamic> toMap() => {
        "itemid": itemid,
        "name": name,
        "address": address,
        "category": category.toMap(),
        "description": description,
        "userid": userid,
        "phone": phone,
        "images": List<dynamic>.from(images.map((x) => x.toMap())),
        "amount": amount,
        "price": price,
        "viewers": List<dynamic>.from(viewers.map((x) => x)),
        "views": views,
        "date": date.toIso8601String(),
      };
}



