import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mygoods_flutter/models/item.dart';
import 'package:mygoods_flutter/services/ItemService.dart';
import 'package:mygoods_flutter/views/ItemDetailPage.dart';

class ListItemRow extends StatefulWidget {
  const ListItemRow({
    Key? key,
    required this.item,
    this.onTap,
  }) : super(key: key);
  final Item item;
  final Function()? onTap;

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
      // padding: const EdgeInsets.only(left: 10,right: 10),
      child: Column(children: [
        InkWell(
          onTap: widget.onTap ??
              () {
                Get.to(() => ItemDetailPage(
                      item: item,
                    ));
              },
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: CachedNetworkImage(
                  imageUrl: item.images[0].imageUrl,
                  width: 125,
                  height: 125,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                width: 15,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  Divider(
                    height: 12,
                  ),
                  Text(
                    "USD \$${item.price}",
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  Divider(
                    height: 12,
                  ),
                  FutureBuilder<String>(
                    future: database.getItemOwnerName(item.userid),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text(
                          "Post By ${snapshot.data}",
                          style: TextStyle(fontSize: 12),
                        );
                      } else {
                        return Text(
                          "Post By someone",
                          style: TextStyle(fontSize: 12),
                        );
                      }
                    },
                  ),
                  Divider(
                    height: 2,
                  ),
                  Text(
                    "Posted ${calDate(item.date)}",
                    style: TextStyle(fontSize: 12),
                  ),
                  Divider(
                    height: 2,
                  ),
                  Text(
                    "Views: ${item.views}",
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Divider(
          // height: 2,
          thickness: 2,
          color: Colors.blueGrey,
        )
      ]),
    );
  }
}
