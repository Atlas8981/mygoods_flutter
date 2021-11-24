import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:mygoods_flutter/components/custom_alert_dialog.dart';
import 'package:mygoods_flutter/controllers/myItemsController.dart';
import 'package:mygoods_flutter/models/item.dart';
import 'package:mygoods_flutter/services/item_database_service.dart';
import 'package:mygoods_flutter/services/user_service.dart';
import 'package:mygoods_flutter/views/ListProduct.dart';
import 'package:mygoods_flutter/views/cells/list_product_row.dart';
import 'package:mygoods_flutter/views/edit_item_page.dart';
import 'package:mygoods_flutter/views/owner_item_detail_page.dart';

class MyItemsPage extends StatelessWidget {
  MyItemsPage({Key? key}) : super(key: key);

  final userService = UserService();

  final myItemController = Get.put(MyItemsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Item(s)"),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(10),
          child: GetBuilder<MyItemsController>(
            init: myItemController,
            builder: (controller) {
              if (controller.items.length == 0) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              final items = controller.items;
              // print(items);
              return ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return OwnerItemRow(
                    item: items[index],
                    onDelete: () {
                      onClickDeleteItem(context, items[index]);
                    },
                    onEdit: onClickEditItem,
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void onClickEditItem() {
    Get.to(()=> EditItemPage());
  }

  void onClickDeleteItem(context, Item item) {
    showCustomDialog(
      context,
      title: "Are you sure you want to delete this item ?",
      onConfirm: () {
        myItemController.deleteItems(item);
        Get.back();
      },
    );
  }
}

class OwnerItemRow extends StatelessWidget {
  OwnerItemRow({
    Key? key,
    required this.item,
    this.onTap,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);
  final Item item;
  final Function()? onTap;
  final Function()? onEdit;
  final Function()? onDelete;

  final ItemDatabaseService database = ItemDatabaseService();

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

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // padding: const EdgeInsets.only(left: 10,right: 10),
      child: Column(children: [
        InkWell(
          onTap: () {
            Get.to(() => OwnerItemDetailPage(item: item));
          },
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: Image.network(
                  item.images[0].imageUrl,
                  width: 125,
                  height: 125,
                  fit: BoxFit.cover,
                  cacheHeight: 125,
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: onEdit,
                      icon: Icon(Icons.edit),
                      padding: EdgeInsets.all(0),
                      alignment: Alignment.topCenter,
                    ),
                    IconButton(
                      onPressed: onDelete,
                      icon: Icon(Icons.delete_outline),
                      padding: EdgeInsets.all(0),
                      alignment: Alignment.bottomCenter,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        const Divider(
          thickness: 2,
          color: Colors.blueGrey,
        )
      ]),
    );
  }
}
