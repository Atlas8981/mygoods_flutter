import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mygoods_flutter/models/category.dart';
import 'package:mygoods_flutter/utils/constant.dart';
import 'package:mygoods_flutter/views/cells/category_item_row.dart';
import 'package:mygoods_flutter/views/cells/popular_category_item.dart';

import 'SubCategoryPage.dart';

class CategoryPage extends StatelessWidget {
  CategoryPage({
    Key? key,
  }) : super(key: key);

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
        title: const Text("Category"),
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.maxFinite,
          height: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Popular Category",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      GridView.count(
                        scrollDirection: Axis.vertical,
                        childAspectRatio: (85 / 90),
                        shrinkWrap: true,
                        crossAxisCount: 3,
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
                const SizedBox(
                  width: double.maxFinite,
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text(
                        "More Categories",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        width: double.infinity,
                        height: 20,
                      ),
                      ListView.builder(
                        physics: const ScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: mainCategories.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Get.to(
                                () => SubCategoryPage(
                                  title: mainCategories[index].name,
                                ),
                              );
                            },
                            child: CategoryItemRow(
                              name: mainCategories[index].name,
                              assetImage: mainCategories[index].image,
                            ),
                          );
                        },
                      )
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
