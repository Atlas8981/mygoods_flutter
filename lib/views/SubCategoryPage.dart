import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mygoods_flutter/models/category.dart';
import 'package:mygoods_flutter/utils/constant.dart';
import 'package:mygoods_flutter/views/ListItems.dart';
import 'package:mygoods_flutter/views/cells/category_item_row.dart';

class SubCategoryPage extends StatelessWidget {
  const SubCategoryPage({
    Key? key,
    required this.title,
  }) : super(key: key);

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
      body: SizedBox(
        width: double.maxFinite,
        height: double.maxFinite,
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
                        Get.to(
                          () => ListItem(
                            mainCat: title,
                            subCat: decideSubCategory()[index].name,
                          ),
                        );
                      },
                      child: CategoryItemRow(
                        name: decideSubCategory()[index].name,
                        assetImage: decideSubCategory()[index].image,
                      ));
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
