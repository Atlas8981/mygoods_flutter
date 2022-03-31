import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:mygoods_flutter/models/item.dart';
import 'package:mygoods_flutter/services/ItemService.dart';

class ListItemRow extends StatefulWidget {
  const ListItemRow({
    Key? key,
    required this.item,
  }) : super(key: key);
  final Item item;

  @override
  _ListItemRowState createState() => _ListItemRowState();
}

class _ListItemRowState extends State<ListItemRow> {
  final ItemService database = ItemService();

  String calDate(Timestamp itemDate) {
    //Convert to second
    double date = (Timestamp.now().seconds - itemDate.seconds).toDouble();
    String timeEnd = " second(s)";
    if (date > 0) {
      if (date >= 60) {
        date = date / 60;
        timeEnd = " minutes(s) ";
        if (date >= 60) {
          date = date / 60;
          timeEnd = " hours(s) ";
          if (date >= 24) {
            date = date / 24;
            timeEnd = " day(s) ";
            if (date > 7) {
              date = date / 7;
              timeEnd = " week(s)";
              if (date > 4) {
                date = date / 4;
                timeEnd = " month(s)";
                // if(date>12){
                //   date = date/12.roundToDouble();
                //   timeEnd = " year(s)";
                // }
              }
            }
          }
        }
      }
    }
    return "${date.toInt()}" + timeEnd;
  }

  late final item = widget.item;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
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
              const SizedBox(width: 15),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(
                    height: 12,
                  ),
                  Text(
                    "USD \$${item.price}",
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(
                    height: 12,
                  ),
                  FutureBuilder<String>(
                    future: database.getItemOwnerName(item.userid),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text(
                          "Post By ${snapshot.data}",
                          style: const TextStyle(fontSize: 12),
                        );
                      } else {
                        return const Text(
                          "Post By someone",
                          style: TextStyle(fontSize: 12),
                        );
                      }
                    },
                  ),
                  const Divider(
                    height: 2,
                  ),
                  Text(
                    "Posted ${calDate(item.date)}",
                    style: const TextStyle(fontSize: 12),
                  ),
                  const Divider(
                    height: 2,
                  ),
                  Text(
                    "Views: ${item.views}",
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
