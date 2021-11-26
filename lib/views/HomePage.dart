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
        images: [myImage.Image(imageName: "imageName", imageUrl: "$dummyNetworkImage")],
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
        images: [myImage.Image(imageName: "imageName", imageUrl: "$dummyNetworkImage")],
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
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(left: 10,right: 20),
            child: Column(children: [
              SizedBox(
                height: 10,
              ),
              Container(
                color: Colors.blue,
                height: 125,
                width: double.infinity,
                child: Image.asset(
                  "assets/images/banner1.png",
                  fit: BoxFit.cover,
                ),
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Trending",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text("View All"),
                      ),
                    ],
                  ),
                  SizedBox(
                    // width: double.infinity,
                    height: 175,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      // shrinkWrap: true,
                      // physics: NeverScrollableScrollPhysics(),
                      itemCount: itemList.length,
                      itemBuilder: (BuildContext context, int index) {
                        // return ProductTile(productList[index]);
                        return HomepageCell(itemList[index]);
                      },
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Recently View",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text("View All"),
                      ),
                    ],
                  ),
                  SizedBox(
                    // width: double.infinity,
                    height: 175,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: itemList.length,
                      itemBuilder: (BuildContext context, int index) {
                        // return ProductTile(productList[index]);
                        return HomepageCell(itemList[index]);
                      },
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "You May Like",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text("View All"),
                      ),
                    ],
                  ),
                  SizedBox(
                    // width: double.infinity,
                    height: 175,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: itemList.length,
                      itemBuilder: (BuildContext context, int index) {
                        // return ProductTile(productList[index]);
                        return HomepageCell(itemList[index]);
                      },
                    ),
                  ),
                ],
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
