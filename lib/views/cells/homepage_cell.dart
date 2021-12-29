import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mygoods_flutter/models/item.dart';
import 'package:mygoods_flutter/views/ItemDetailPage.dart';

class HomepageCell extends StatelessWidget {
  const HomepageCell(this.item, {Key? key}) : super(key: key);

  final Item item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 10),
      width: 125,
      child: InkWell(
        onTap: () {
          Get.to(() => ItemDetailPage(item: item));
        },
        child: Column(
          // direction: Axis.vertical,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                child: Image.network(
                  item.images[0].imageUrl,
                  width: 125,
                  height: 125,
                  fit: BoxFit.cover,
                  cacheHeight: 500,
                )
                // CachedNetworkImage(
                //   imageUrl: item.images[0].imageUrl,
                //   width: 125,
                //   height: 125,
                //   fit: BoxFit.cover,
                //
                // ),
                ),
            Text(
              item.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text("USD ${item.price}"),
          ],
        ),
      ),
    );
    // return Card(
    //   child: Column(
    //     // mainAxisSize: MainAxisSize.max,
    //     children: [
    //       SizedBox(
    //         child: Image.network(
    //           product.image,
    //           width: 125,
    //           height: 125,
    //           fit: BoxFit.cover,
    //         ),
    //       ),
    //       Text("${product.title}",),
    //       Text("USD \$ ${product.price}",),
    //       // Text("USD \$ ${product.price}",),
    //
    //     ],
    //   ),
    // );
  }
}
