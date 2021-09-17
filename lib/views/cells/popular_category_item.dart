

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mygoods_flutter/models/category.dart';

class PopularCategoryRow extends StatelessWidget {

  final Category category;
  const PopularCategoryRow(this.category);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){},
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            width: 85,
            height: 85,
            // child: Column(
            // mainAxis in column in top->bottom
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            // children: [
            //   ClipRRect(
            //     borderRadius: BorderRadius.circular(10),
            //     child: Image.network(
            //       "https://firebasestorage.googleapis.com/v0/b/mygoods-e042f.appspot.com/o/images%2F05411168-1699-4119-a7af-b9017e2df1bd?alt=media&token=b4677321-c035-4cb4-9fc1-7cd869ebc017",
            //       fit: BoxFit.fill,
            //       height: 85,
            //       width: 85,
            //     ),
            //
            //   ),
            // ],
            // ),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    category.image
                ),
                fit: BoxFit.cover,
              ),
              borderRadius:
              BorderRadius.all(Radius.circular(100)),
            ),
          ),
          Text(
            category.name,
            style: TextStyle(
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
