
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mygoods_flutter/models/item.dart';

class HomepageCell extends StatelessWidget {

  const HomepageCell(this.item);
  final Item item;

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 150,
      child: Card(
        child: InkWell(
          onTap: () => {},
          child: Wrap(
            direction: Axis.vertical,
            children: [
              CachedNetworkImage(
                imageUrl: item.images[0].imageUrl,
                width: 125,
                height: 125,
                fit: BoxFit.cover,
              ),
              Text("${item.name}"),
              Text("USD ${item.price}"),
            ],
          ),
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
