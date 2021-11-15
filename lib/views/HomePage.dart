
import 'package:flutter/material.dart';
import 'package:mygoods_flutter/models/product.dart';
import 'package:mygoods_flutter/views/cells/homepage_cell.dart';

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
    return Scaffold(
      appBar: AppBar(title: Text("Home"),),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(children: [
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
                      // shrinkWrap: true,
                      // physics: NeverScrollableScrollPhysics(),
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
        ),
      ),
    );
  }
}
