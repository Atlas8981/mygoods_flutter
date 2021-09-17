import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mygoods_flutter/models/category.dart';
import 'package:mygoods_flutter/views/SubCategoryPage.dart';

class CategoryItemRow extends StatelessWidget {
  final Category category;
  const CategoryItemRow(this.category);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            // color: Colors.red,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Icon(
                  //     Icons.camera,
                  //   size: 25,
                  // ),
                  Image.asset(
                    category.image,
                    width: 25,
                    height: 25,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: Text(
                    category.name,
                    style: TextStyle(fontSize: 13),
                  )),
                  Icon(Icons.arrow_forward_ios),
                  SizedBox(
                    width: 10,
                  )
                ]),
          ),
          Container(
            width: double.infinity,
            height: 3,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}
