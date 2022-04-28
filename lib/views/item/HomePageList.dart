import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mygoods_flutter/models/item.dart';
import 'package:mygoods_flutter/views/cells/HomePageCell.dart';
import 'package:mygoods_flutter/views/item/ItemDetailPage.dart';
import 'package:mygoods_flutter/views/item/ViewAllPage.dart';

class HomePageList extends StatelessWidget {
  const HomePageList({
    Key? key,
    required this.title,
    required this.onTap,
    required this.items,
  }) : super(key: key);
  final String title;
  final Function() onTap;
  final List<Item> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                Get.to(
                  () => ViewAllPage(
                    title: title,
                    smallListItem: items,
                  ),
                );
              },
              child: Text("more".tr),
            ),
          ],
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: (items.length <= 3) ? Get.width : null,
            child: Row(
              children: items
                  .map((Item i) {
                    return HomePageCell(
                      item: i,
                      destination: ItemDetailPage(item: i),
                    );
                  })
                  .toList()
                  .cast(),
            ),
          ),
        ),
      ],
    );
  }
}
