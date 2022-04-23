import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mygoods_flutter/models/item.dart';
import 'package:mygoods_flutter/utils/constant.dart';
import 'package:mygoods_flutter/views/item/ItemDetailPage.dart';

class BigImageCell extends StatefulWidget {
  const BigImageCell({
    Key? key,
    required this.item,
    this.destination,
  }) : super(key: key);
  final Item item;
  final dynamic destination;

  @override
  State<BigImageCell> createState() => _BigImageCellState();
}

class _BigImageCellState extends State<BigImageCell> {
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
          Get.to((() => ItemDetailPage(item: item)));
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
              child: AspectRatio(
                aspectRatio: 16 / 10,
                child: ExtendedImage.network(
                  item.images[0].imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontSize: 24,
                    ),
                  ),
                  commonHeightPadding(),
                  Text(
                    "USD \$${item.price}",
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  commonHeightPadding(),
                  Text(
                    "Posted ${calDate(item.date)}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  commonHeightPadding(),
                  Text(
                    "Views: ${item.viewers.length}",
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
