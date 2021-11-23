import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mygoods_flutter/controllers/productController.dart';
import 'package:mygoods_flutter/models/category.dart';
import 'package:mygoods_flutter/utils/constant.dart';
import 'package:mygoods_flutter/views/cells/category_item_row.dart';
import 'package:mygoods_flutter/views/cells/popular_category_item.dart';

import 'SubCategoryPage.dart';

class CategoryPage extends StatelessWidget {
  final productController = Get.put(ProductController());

  final List<Category> popularCategory = [
    Category(name: "Phone", image: "${imageDir}phonepicture.jpg"),
    Category(name: "Bicycle", image: "${imageDir}bikepicture.jpg"),
    Category(name: "Cars", image: "${imageDir}carpic.png"),
    Category(name: "Parts & Accessories", image: "${imageDir}pc.jpg"),
    Category(name: "Laptop", image: "${imageDir}laptoppicture.jpg"),
    Category(name: "Desktop", image: "${imageDir}desktoppic.png"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Category"),
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          // color: Colors.yellow,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Popular Category",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      GridView.count(
                        scrollDirection: Axis.vertical,
                        //Very Important Line to make grid view scroll
                        physics: ScrollPhysics(),
                        shrinkWrap: true,
                        primary: true,
                        crossAxisCount: 3,
                        //1.0
                        crossAxisSpacing: 4.0,
                        children: List.generate(
                          popularCategory.length,
                          (index) {
                            return PopularCategoryRow(popularCategory[index]);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 10,
                  color: Colors.black,
                ),
                Container(
                  width: double.infinity,
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "More Categories",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Container(
                        width: double.infinity,
                        height: 20,
                      ),
                      ListView.builder(
                        physics: ScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: mainCategories.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                              onTap: () {
                                // print("category" + mainCategories[index].name);
                                Get.to(() => SubCategoryPage(
                                  title:  mainCategories[index].name,
                                ),);
                              },
                              child: CategoryItemRow(mainCategories[index]));
                        },
                      )
                      //  Put Column
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
