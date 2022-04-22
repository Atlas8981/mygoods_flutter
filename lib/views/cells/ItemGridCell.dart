import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mygoods_flutter/models/item.dart';
import 'package:mygoods_flutter/services/ItemService.dart';
import 'package:mygoods_flutter/utils/constant.dart';

class ItemGridCell extends StatefulWidget {
  const ItemGridCell({
    Key? key,
    required this.item,
    required this.destination,
  }) : super(key: key);

  final Item item;
  final Widget destination;

  @override
  State<ItemGridCell> createState() => _ItemGridCellState();
}

class _ItemGridCellState extends State<ItemGridCell> {
  final itemService = ItemService();

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    return InkWell(
      onTap: () {
        Get.to(() => widget.destination);
      },
      child: mainItemCell(item),
    );
  }

  Widget mainItemCell(Item item) {
    return Column(
      children: [
        ClipRRect(
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
        SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.max,
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
              Text(
                "USD \$${item.price}",
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                  height: 1.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
                  return const Text(
                    "Post By someone",
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.5,
                    ),
                  );
                },
              ),
              Text(
                "Posted ${calDate(item.date)}",
                style: const TextStyle(
                  fontSize: 12,
                  height: 1.5,
                ),
              ),
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
