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
        title: "title",
        price: 0.0,
        description: "description",
        image: "https://firebasestorage.googleapis.com/v0/b/mygoods-e042f.appspot.com/o/images%2F05411168-1699-4119-a7af-b9017e2df1bd?alt=media&token=b4677321-c035-4cb4-9fc1-7cd869ebc017",
        rating: Rating(rate: 0.0)
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Container(
            color: Colors.blue,
            child: SizedBox(
              height: 125,
              width: double.infinity,
            ),
          ),
          Padding(padding: EdgeInsets.all(2.5)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  "Trending",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold
                ),
              ),
              TextButton(
                  onPressed: (){},
                  child: Text("View All"),
              ),
            ],
          ),
          Padding(padding: EdgeInsets.all(2.5)),
          SizedBox(
            height: 125,
            width: double.infinity,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: productList.length,
              itemBuilder: (BuildContext context, int index){
                // return ProductTile(productList[index]);
                return HomepageCell(productList[index]);
              },
            ),
          ),
          // Expanded(
          //   child: ListView(
          //     scrollDirection: Axis.horizontal,
          //     children: [
          //       Container(width: 160.0, color: Colors.blue,),
          //       Container(width: 160.0, color: Colors.red,),
          //       Container(width: 160.0, color: Colors.black,),
          //       Container(width: 160.0, color: Colors.amber,),
          //     ],
          //   ),
          // ),
        ],
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