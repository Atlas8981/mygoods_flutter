import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:mygoods_flutter/controllers/productController.dart';
import 'package:mygoods_flutter/models/product.dart';
import 'package:mygoods_flutter/views/cells/homepage_cell.dart';
import 'package:mygoods_flutter/views/cells/product_tile.dart';

class HomePage extends StatelessWidget {
  final productList = [
    Product(
        id: 012,
        title: "iPhone XL",
        price: 0.0,
        description: "description",
        image:
            "https://firebasestorage.googleapis.com/v0/b/mygoods-e042f.appspot.com/o/images%2F05411168-1699-4119-a7af-b9017e2df1bd?alt=media&token=b4677321-c035-4cb4-9fc1-7cd869ebc017",
        rating: Rating(rate: 0.0,count: 0)),
    Product(
        id: 013,
        title: "title",
        price: 0.0,
        description: "description",
        image:
            "https://firebasestorage.googleapis.com/v0/b/mygoods-e042f.appspot.com/o/images%2F05411168-1699-4119-a7af-b9017e2df1bd?alt=media&token=b4677321-c035-4cb4-9fc1-7cd869ebc017",
        rating: Rating(rate: 0.0,count: 0)),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(children: [
          Container(
            color: Colors.blue,
            height: 125,
            width: double.infinity,
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Trending",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                  itemCount: productList.length,
                  itemBuilder: (BuildContext context, int index) {
                    // return ProductTile(productList[index]);
                    return HomepageCell(productList[index]);
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
                    style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                  itemCount: productList.length,
                  itemBuilder: (BuildContext context, int index) {
                    // return ProductTile(productList[index]);
                    return HomepageCell(productList[index]);
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
                    style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                  itemCount: productList.length,
                  itemBuilder: (BuildContext context, int index) {
                    // return ProductTile(productList[index]);
                    return HomepageCell(productList[index]);
                  },
                ),
              ),
            ],
          ),

        ]),
      ),
    );
  }
// const HomePage({ Key? key }) : super(key: key);

// final productController = Get.put(ProductController());
//
// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//
//     body: Obx(() => StaggeredGridView.countBuilder(
//         crossAxisCount: 2,
//         itemCount: productController.productList.length,
//         mainAxisSpacing: 16,
//         crossAxisSpacing: 16,
//         itemBuilder: (context, index) {
//           return ProductTile(productController.productList[index]);
//         },
//         staggeredTileBuilder: (index) => StaggeredTile.fit(1))),
//     // body: Obx(() {
//     //   return Text("Something is herer ${productController.productList.length}");
//     // }),
//   );
// }
}
