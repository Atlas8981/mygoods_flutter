import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mygoods_flutter/models/item.dart';
import 'package:mygoods_flutter/services/database_service.dart';

class ListItemRow extends StatefulWidget {
  const ListItemRow({Key? key, this.item}) : super(key: key);
  final Item? item;

  @override
  _ListItemRowState createState() => _ListItemRowState();
}

class _ListItemRowState extends State<ListItemRow> {
  DatabaseService database = DatabaseService();

  // getItemOwner(String userId);

  String calDate(Timestamp itemDate){
    //Convert to second
    double date = (Timestamp.now().seconds - itemDate.seconds).toDouble();
    String timeEnd = "second(s)";
    if (date > 0) {
      if (date >= 60) {
        date = date / 60;
        timeEnd = " minutes(s) ";
        if(date >= 60){
          date = date / 60;
          timeEnd = " hours(s) ";
          if (date >= 24) {
            date = date/24;
            timeEnd = " day(s) ";
            if(date>7){
              date = date/7;
              timeEnd = " week(s)";
              if (date>4){
                date = date/4;
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

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    return Container(
      width: double.infinity,
      // padding: const EdgeInsets.only(left: 10,right: 10),
      child: Column(children: [
        Row(
          children: [
            Image.network(
              // "assets/images/bikepicture.jpg",
              item!.images[0].imageUrl,
              width: 125,
              height: 125,
              fit: BoxFit.cover,
              cacheHeight: 125,
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
                  future: database.getItemOwner(item.userid),
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
                  "Views: 118",
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ],
        ),
        const Divider(
          // height: 2,
          thickness: 2,
          color: Colors.grey,
        )
      ]),
    );
  }
}
