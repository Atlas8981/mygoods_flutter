import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mygoods_flutter/models/category.dart';

class CategoryItemRow extends StatelessWidget {

  const CategoryItemRow(this.category);
  final Category category;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      // padding: EdgeInsets.only(bottom: 20),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
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
          SizedBox(
            width: double.infinity,
            height: 5,
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
