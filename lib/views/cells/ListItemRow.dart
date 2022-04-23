import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:mygoods_flutter/models/item.dart';
import 'package:mygoods_flutter/services/ItemService.dart';
import 'package:mygoods_flutter/utils/constant.dart';
import 'package:mygoods_flutter/views/item/ItemDetailPage.dart';

class ListItemRow extends StatefulWidget {
  const ListItemRow({
    Key? key,
    required this.item,
    this.destination,
  }) : super(key: key);
  final Item item;
  final dynamic destination;

  @override
  _ListItemRowState createState() => _ListItemRowState();
}

class _ListItemRowState extends State<ListItemRow> {
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
      shadowColor: Colors.black,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: InkWell(
        onTap: () {
          Get.to(widget.destination ?? () => ItemDetailPage(item: item));
        },
        child: mainItemRow(item),
      ),
    );
  }

  Widget mainItemRow(Item item) {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.all(8),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
            child: ExtendedImage.network(
              item.images[0].imageUrl,
              width: 125,
              height: 125,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.name,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
            commonHeightPadding(),
            Text(
              "USD \$${formatPrice(item.price)}",
              style: const TextStyle(
                color: Colors.red,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            commonHeightPadding(),
            FutureBuilder<String>(
              future: itemService.getItemOwnerName(item.userid),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(
                    "${"postBy".tr} ${snapshot.data}",
                    style: const TextStyle(fontSize: 12),
                  );
                } else {
                  return Container();
                }
              },
            ),
            commonHeightPadding(),
            Text(
              calDate(item.date),
              style: const TextStyle(fontSize: 12),
            ),
            commonHeightPadding(),
            Text(
              "${"view".tr}: ${item.viewers.length}",
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }
}
