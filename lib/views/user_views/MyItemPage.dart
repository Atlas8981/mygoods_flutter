import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:mygoods_flutter/components/CustomAlertDialog.dart';
import 'package:mygoods_flutter/controllers/MyItemsController.dart';
import 'package:mygoods_flutter/models/my_item.dart';
import 'package:mygoods_flutter/services/ItemService.dart';
import 'package:mygoods_flutter/services/UserService.dart';
import 'package:mygoods_flutter/views/user_views/EditItemPage.dart';
import 'package:mygoods_flutter/views/OwnerItemDetailPage.dart';

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
        child: GetBuilder<MyItemsController>(
          init: myItemController,
          builder: (controller) {
            if (controller.items == null) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            final List<MyItem> items = controller.items!.cast();
            if (items.isEmpty) {
              return Center(
                child: Text("You have no items"),
              );
            }
            return Container(
              padding: EdgeInsets.only(
                top: 10,
                left: 10,
                right: 10,
              ),
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return OwnerItemRow(
                    item: items[index],
                    onDelete: () {
                      onClickDeleteItem(context, items[index]);
                    },
                    onEdit: () {
                      onClickEditItem(items[index]);
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  void onClickEditItem(MyItem item) {
    Get.to(() => EditItemPage(
          item: item,
        ));
  }

  void onClickDeleteItem(context, MyItem item) {
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
  final MyItem item;
  final Function()? onTap;
  final Function()? onEdit;
  final Function()? onDelete;

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

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
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
                child: (item.images.isNotEmpty)
                    ? Image.network(
                        item.images[0].imageUrl,
                        width: 125,
                        height: 125,
                        fit: BoxFit.cover,
                        cacheHeight: 125,
                      )
                    : SizedBox(
                        width: 125, height: 125, child: Icon(Icons.camera)),
              ),
              SizedBox(
                width: 15,
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Text(
                      "USD \$${item.price}",
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
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
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Posted ${calDate(item.date)}",
                      style: TextStyle(fontSize: 12),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Views: ${item.views}",
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 125,
                // color: Colors.cyan,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    IconButton(
                      onPressed: onEdit,
                      icon: Icon(
                        Icons.edit,
                      ),
                      padding: EdgeInsets.all(0),
                    ),
                    IconButton(
                      onPressed: onDelete,
                      icon: Icon(
                        Icons.delete_outline,
                      ),
                      padding: EdgeInsets.all(0),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        Divider(
          thickness: 2,
          color: Colors.grey.withOpacity(0.5),
        )
      ]),
    );
  }
}
