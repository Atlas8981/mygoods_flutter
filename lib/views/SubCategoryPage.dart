import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mygoods_flutter/models/category.dart';
import 'package:mygoods_flutter/utils/constant.dart';
import 'package:mygoods_flutter/views/ListProduct.dart';
import 'package:mygoods_flutter/views/cells/category_item_row.dart';

class SubCategoryPage extends StatelessWidget {
  const SubCategoryPage({
    required this.title,
  });

  final String title;

  List<Category> decideSubCategory() {
    if (title == "Electronic") {
      return electronicSubCategories;
    } else if (title == "Car & Vehicle") {
      return carSubCategories;
    } else {
      return furnitureSubCategories;
    }
  }

  @override
  Widget build(BuildContext context) {
    // print("Sub category" + Get.arguments);
    // final String title = Get.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // color: Colors.red,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ListView.builder(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                primary: true,
                itemCount: decideSubCategory().length,
                itemBuilder: (context, index) {
                  return InkWell(
                      onTap: () {
                        Get.to(() => ListProduct(), arguments: [
                          title,
                          decideSubCategory()[index].name,
                        ]);
                      },
                      child: CategoryItemRow(decideSubCategory()[index]));
                },
              )
              //  Put Column
            ],
          ),
        ),
      ),
    );
  }
}
