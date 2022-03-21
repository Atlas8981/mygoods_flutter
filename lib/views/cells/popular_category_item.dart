import 'package:flutter/material.dart';
import 'package:mygoods_flutter/models/category.dart';

class PopularCategoryCell extends StatelessWidget {
  final Category category;

  const PopularCategoryCell(
    this.category, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            width: 85,
            height: 85,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(category.image),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.all(Radius.circular(100)),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Text(
                category.name,
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
