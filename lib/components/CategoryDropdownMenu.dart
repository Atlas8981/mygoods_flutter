import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mygoods_flutter/models/category.dart';
import 'package:mygoods_flutter/utils/constant.dart';

class CategoryDropdownMenu extends StatefulWidget {
  const CategoryDropdownMenu({
    Key? key,
    this.onConfirm,
  }) : super(key: key);

  final Function(String main, String sub)? onConfirm;

  @override
  _CategoryDropdownMenuState createState() => _CategoryDropdownMenuState();
}

class _CategoryDropdownMenuState extends State<CategoryDropdownMenu> {
  String mainCategory = mainCategories[0].name;
  String? subCategory;
  List<Category>? subCategories;

  void findSubCategory() {
    if (mainCategory == mainCategories[0].name) {
      subCategories = electronicSubCategories;
      subCategory = electronicSubCategories[0].name;
    } else if (mainCategory == mainCategories[1].name) {
      subCategories = carSubCategories;
      subCategory = carSubCategories[0].name;
    } else {
      subCategories = furnitureSubCategories;
      subCategory = furnitureSubCategories[0].name;
    }
  }

  @override
  Widget build(BuildContext context) {
    subCategories ??= electronicSubCategories;
    subCategory ??= electronicSubCategories[0].name;
    return Container(
      width: Get.width,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("mainCategory".tr),
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: DropdownButton<String>(
              value: mainCategory,
              isExpanded: true,
              items: mainCategories.map((value) {
                return DropdownMenuItem<String>(
                  value: value.name,
                  child: Text(value.name.tr),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  mainCategory = value!;
                  findSubCategory();
                });
              },
            ),
          ),
          Text("subCategory".tr),
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: DropdownButton<String>(
              value: subCategory,
              isExpanded: true,
              items: subCategories!.map((value) {
                return DropdownMenuItem<String>(
                  value: value.name,
                  child: Text(value.name.tr),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    subCategory = value;
                  });
                }
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Get.back(closeOverlays: true);
                },
                child: Text("cancel".tr),
              ),
              TextButton(
                onPressed: () {
                  Get.back();
                  if (widget.onConfirm != null) {
                    if (subCategory != null) {
                      widget.onConfirm!(mainCategory, subCategory!);
                    }
                  }
                },
                child: Text("confirm".tr),
              ),
            ],
          )
        ],
      ),
    );
  }
}
