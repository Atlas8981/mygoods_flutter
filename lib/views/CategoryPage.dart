import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mygoods_flutter/models/item/category.dart';
import 'package:mygoods_flutter/utils/constant.dart';
import 'package:mygoods_flutter/views/AboutMePage.dart';
import 'package:mygoods_flutter/views/cells/category_item_row.dart';
import 'package:mygoods_flutter/views/cells/popular_category_item.dart';

import 'SubCategoryPage.dart';

class CategoryPage extends StatelessWidget {
  final List<MenuItem> popularCategory = [
    MenuItem(name: "Phone", image: "${imageDir}phonepicture.jpg"),
    MenuItem(name: "Bicycle", image: "${imageDir}bikepicture.jpg"),
    MenuItem(name: "Cars", image: "${imageDir}carpic.png"),
    MenuItem(name: "Parts & Accessories", image: "${imageDir}pc.jpg"),
    MenuItem(name: "Laptop", image: "${imageDir}laptoppicture.jpg"),
    MenuItem(name: "Desktop", image: "${imageDir}desktoppic.png"),
  ];

  CategoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Category"),
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.maxFinite,
          height: double.maxFinite,
          // color: Colors.yellow,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Popular Category",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      GridView.count(
                        scrollDirection: Axis.vertical,
                        //Very Important Line to make grid view scroll
                        // physics: ScrollPhysics(),
                        childAspectRatio: (85 / 90),
                        shrinkWrap: true,
                        // primary: true,
                        crossAxisCount: 3,
                        //1.0
                        crossAxisSpacing: 4.0,
                        children: List.generate(
                          popularCategory.length,
                          (index) {
                            return PopularCategoryCell(popularCategory[index]);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.maxFinite,
                  height: 5,
                  color: Colors.black.withOpacity(0.2),
                ),
                SizedBox(
                  width: double.maxFinite,
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
                      SizedBox(
                        width: double.infinity,
                        height: 20,
                      ),
                      ListView.builder(
                        physics: ScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: 1,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Get.to(
                                () => SubCategoryPage(),
                              );
                            },
                            child: CategoryItemRow(
                              name: "Electronic",
                              assetImage: "${imageDir}accessory.png",
                            ),
                          );
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
