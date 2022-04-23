import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mygoods_flutter/models/category.dart';
import 'package:mygoods_flutter/utils/constant.dart';
import 'package:mygoods_flutter/views/item/ListItemByPopularCategoryPage.dart';
import 'package:mygoods_flutter/views/cells/MenuItemRow.dart';
import 'package:mygoods_flutter/views/cells/PopularCategoryCell.dart';

import 'SubCategoryPage.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({
    Key? key,
  }) : super(key: key);

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
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
        title: Text("category".tr),
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
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${"category".tr}${"popular".tr}",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      GridView.count(
                        scrollDirection: Axis.vertical,
                        childAspectRatio: (8 / 9),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 3,
                        crossAxisSpacing: 4.0,
                        mainAxisSpacing: 0,
                        children: List.generate(
                          popularCategory.length,
                          (index) {
                            return PopularCategoryCell(
                              popularCategory[index],
                              destination: ListItemByPopularSubCategoryPage(
                                subCat: popularCategory[index].name,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  thickness: 5,
                  color: Colors.black.withOpacity(0.2),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'moreCategory'.tr,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        separatorBuilder: (context, index) {
                          return Divider(
                            height: 0,
                            thickness: 2,
                          );
                        },
                        padding: EdgeInsets.zero,
                        itemCount: mainCategories.length,
                        itemBuilder: (context, index) {
                          return MenuItemRow(
                            onTap: () {
                              Get.to(
                                () => SubCategoryPage(
                                  title: mainCategories[index].name,
                                ),
                              );
                            },
                            name: mainCategories[index].name,
                            assetImage: mainCategories[index].image,
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
