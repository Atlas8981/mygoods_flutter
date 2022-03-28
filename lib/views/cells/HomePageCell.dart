import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:mygoods_flutter/models/item.dart';

class HomePageCell extends StatelessWidget {
  const HomePageCell(
    this.item, {
    Key? key,
  }) : super(key: key);

  final Item item;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 125,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.all(
              Radius.circular(5),
            ),
            child: ExtendedImage.network(
              item.images[0].imageUrl,
              width: 125,
              height: 125,
              fit: BoxFit.cover,
              cacheHeight: 300,
            ),
          ),
          Text(
            item.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text("USD ${item.price}"),
        ],
      ),
    );
  }
}
