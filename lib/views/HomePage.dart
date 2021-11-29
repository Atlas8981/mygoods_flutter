import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mygoods_flutter/models/image.dart' as myImage;
import 'package:mygoods_flutter/models/item.dart';
import 'package:mygoods_flutter/utils/constant.dart';
import 'package:mygoods_flutter/views/cells/homepage_cell.dart';

class HomePage extends StatelessWidget {
  final itemList = [
    Item(
        date: Timestamp.now(),
        subCategory: "subCategory",
        images: [
          myImage.Image(imageName: "imageName", imageUrl: "$dummyNetworkImage")
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
          myImage.Image(imageName: "imageName", imageUrl: "$dummyNetworkImage")
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
          myImage.Image(imageName: "imageName", imageUrl: "$dummyNetworkImage")
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
          myImage.Image(imageName: "imageName", imageUrl: "$dummyNetworkImage")
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
          myImage.Image(imageName: "imageName", imageUrl: "$dummyNetworkImage")
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
          myImage.Image(imageName: "imageName", imageUrl: "$dummyNetworkImage")
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
          myImage.Image(imageName: "imageName", imageUrl: "$dummyNetworkImage")
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
          myImage.Image(imageName: "imageName", imageUrl: "$dummyNetworkImage")
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

  Widget homePageListView(String title,
      {required Function() onTap, required List<Item> items}) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "$title",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: onTap,
              child: Text("View All"),
            ),
          ],
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: items
                .map((e) {
                  return HomepageCell(e);
                })
                .toList()
                .cast(),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: [
          IconButton(
              onPressed: () {
                showToast("In Development");
              },
              icon: Icon(Icons.search))
        ],
      ),
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          padding: EdgeInsets.only(left: 10, right: 10),
          child: ListView(children: [
            SizedBox(
              height: 10,
            ),
            Image.asset(
              "assets/images/banner1.png",
              fit: BoxFit.cover,
              height: 125,
              width: double.infinity,
            ),
            FutureBuilder<List<Item>>(
              // future: ,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Text("Pg rok data oy");
                } else if (snapshot.hasData) {
                  final List<Item> items = snapshot.data!;
                  return homePageListView("Trending", items: items, onTap: () {
                    showToast("In Development");
                  });
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ]),
        ),
      ),
    );
  }
}
