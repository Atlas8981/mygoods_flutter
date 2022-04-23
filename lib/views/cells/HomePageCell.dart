import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mygoods_flutter/models/item.dart';
import 'package:mygoods_flutter/utils/constant.dart';

class HomePageCell extends StatelessWidget {
  const HomePageCell({
    Key? key,
    required this.item,
    required this.destination,
  }) : super(key: key);

  final Item item;
  final Widget destination;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Container(
        padding: EdgeInsets.fromLTRB(8, 0, 8, 8),
        width: 145,
        child: InkWell(
          onTap: () {
            Get.to(() => destination);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(8),
                ),
                child: ExtendedImage.network(
                  item.images[0].imageUrl,
                  width: 125,
                  height: 125,
                  fit: BoxFit.cover,
                  cacheHeight: 150,
                ),
              ),
              adaptiveHeightSpacing(),
              Text(
                item.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 16),
              ),
              adaptiveHeightSpacing(),
              Text(
                "USD \$${formatPrice(item.price)}",
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
