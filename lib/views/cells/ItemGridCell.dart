import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mygoods_flutter/models/item.dart';
import 'package:mygoods_flutter/services/ItemService.dart';
import 'package:mygoods_flutter/utils/constant.dart';
import 'package:mygoods_flutter/views/item/ItemDetailPage.dart';

class ItemGridCell extends StatefulWidget {
  const ItemGridCell({
    Key? key,
    required this.item,
    this.destination,
  }) : super(key: key);
  final Item item;
  final dynamic destination;

  @override
  State<ItemGridCell> createState() => _ItemGridCellState();
}

class _ItemGridCellState extends State<ItemGridCell> {
  final itemService = ItemService();

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    return Card(
      elevation: 8,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: InkWell(
        onTap: () {
          Get.to(() => ItemDetailPage(item: item));
        },
        child: mainItemCell(item),
      ),
    );
  }

  Widget mainItemCell(Item item) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(8),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(
              Radius.circular(8),
            ),
            child: AspectRatio(
              aspectRatio: 1 / 1,
              child: ExtendedImage.network(
                item.images[0].imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 8,bottom: 4),
          width: double.maxFinite,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  height: 1.5,
                ),
              ),
              commonHeightPadding(),
              Text(
                "USD \$${item.price}",
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                  height: 1.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
              commonHeightPadding(),
              FutureBuilder<String>(
                initialData: "Someone",
                future: itemService.getItemOwnerName(item.userid),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      "Post By ${snapshot.data}",
                      style: const TextStyle(
                        fontSize: 12,
                        height: 1.5,
                      ),
                    );
                  }
                  return Container();
                },
              ),
              commonHeightPadding(),
              Text(
                "Posted ${calDate(item.date)}",
                style: const TextStyle(
                  fontSize: 12,
                  height: 1.5,
                ),
              ),
              commonHeightPadding(),
              Text(
                "Views: ${item.viewers.length}",
                style: const TextStyle(
                  fontSize: 12,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
