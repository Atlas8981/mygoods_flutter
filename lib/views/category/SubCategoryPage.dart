import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mygoods_flutter/models/category.dart';
import 'package:mygoods_flutter/utils/constant.dart';
import 'package:mygoods_flutter/views/item/ListItemByCategoryPage.dart';
import 'package:mygoods_flutter/views/cells/MenuItemRow.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SizedBox(
        width: double.maxFinite,
        height: double.maxFinite,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ListView.separated(
                separatorBuilder: (context, index) {
                  return Divider(
                    height: 0,
                    thickness: 2,
                  );
                },
                shrinkWrap: true,
                primary: true,
                itemCount: decideSubCategory().length,
                itemBuilder: (context, index) {
                  return MenuItemRow(
                    onTap: () {
                      Get.to(
                        () => ListItemByCategoryPage(
                          mainCat: title,
                          subCat: decideSubCategory()[index].name,
                        ),
                      );
                    },
                    name: decideSubCategory()[index].name,
                    assetImage: decideSubCategory()[index].image,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
