

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mygoods_flutter/models/category.dart';
import 'package:mygoods_flutter/views/ListCategoryPage.dart';
import 'package:mygoods_flutter/views/ListProduct.dart';
import 'package:mygoods_flutter/views/cells/category_item_row.dart';

class SubCategoryPage extends StatelessWidget {

  static final String imageDir = "assets/images/";

  List<Category> electronicSubCategory = [
    Category(name: "Phone", image: "${imageDir}phone.png"),
    Category(name: "Desktop", image: "${imageDir}electronic.png"),
    Category(name: "Laptop", image: "${imageDir}laptop.png"),
    Category(name: "Parts & Accessories", image: "${imageDir}accessory.png"),
    Category(name: "Other", image: "${imageDir}other.png"),
  ];

  List<Category> carSubCategory = [
    Category(name: "Cars", image: "${imageDir}car.png"),
    Category(name: "Motorbikes", image: "${imageDir}moto.png"),
    Category(name: "Bicycles", image: "${imageDir}bike.png"),
    Category(name: "Other", image: "${imageDir}other.png"),

  ];
  List<Category> furnitureSubCategory = [
    Category(name: "Table & Desk", image: "${imageDir}table.png"),
    Category(name: "Chair & Sofa", image: "${imageDir}sofa.png"),
    Category(name: "Household Item", image: "${imageDir}household.png"),
    Category(name: "Other", image: "${imageDir}other.png"),
  ];

  List<Category> decideSubCategory() {
    if(Get.arguments == "Electronic"){
      return electronicSubCategory;
    }else if(Get.arguments == "Car & Vehicle"){
      return carSubCategory;
    }else{
      return furnitureSubCategory;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Get.arguments),
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
                      onTap: (){
                        Get.to(ListProduct(),arguments: [
                          Get.arguments,
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
