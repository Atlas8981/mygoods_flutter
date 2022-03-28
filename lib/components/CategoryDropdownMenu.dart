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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text("Main Category"),
        DropdownButton<String>(
          value: mainCategory,
          isExpanded: true,
          items: mainCategories.map((value) {
            return DropdownMenuItem<String>(
              value: value.name,
              child: Text(value.name),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              mainCategory = value!;
              findSubCategory();
            });
          },
        ),
        const Text("Sub Category"),
        DropdownButton<String>(
          value: subCategory,
          isExpanded: true,
          items: subCategories!.map((value) {
            return DropdownMenuItem<String>(
              value: value.name,
              child: Text(value.name),
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
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text("Cancel"),
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
              child: const Text("Confirm"),
            ),
          ],
        )
      ],
    );
  }
}
