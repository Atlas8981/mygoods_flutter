import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mygoods_flutter/models/category.dart';

class PopularCategoryCell extends StatelessWidget {
  const PopularCategoryCell(
    this.category, {
    Key? key,
    required this.destination,
  }) : super(key: key);
  final Category category;
  final Widget destination;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(() => destination);
      },
      child: Column(
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(
              category.image,
            ),
            radius: 40,
          ),
          // const SizedBox(height: 8),
          // Container(
          //   width: 85,
          //   height: 85,
          //   decoration: BoxDecoration(
          //     image: DecorationImage(
          //       image: AssetImage(category.image),
          //       fit: BoxFit.cover,
          //     ),
          //     borderRadius: const BorderRadius.all(
          //       Radius.circular(100),
          //     ),
          //   ),
          // ),
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Text(
                category.name.tr,
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  height: (Get.locale == const Locale('en', 'US')) ? 1.5 : 2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
