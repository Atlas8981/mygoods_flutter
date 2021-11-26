import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mygoods_flutter/components/ImageViews.dart';
import 'package:mygoods_flutter/controllers/MyItemsController.dart';
import 'package:mygoods_flutter/models/additionalInfo.dart';
import 'package:mygoods_flutter/models/item.dart';
import 'package:mygoods_flutter/services/item_database_service.dart';
import 'package:mygoods_flutter/utils/constant.dart';
import 'package:mygoods_flutter/views/EditItemPage.dart';

class OwnerItemDetailPage extends StatefulWidget {
  const OwnerItemDetailPage({
    Key? key,
    required this.item,
  }) : super(key: key);
  final Item? item;

  @override
  State<OwnerItemDetailPage> createState() => _OwnerItemDetailPageState();
}

class _OwnerItemDetailPageState extends State<OwnerItemDetailPage> {
  final firestoreService = ItemDatabaseService();
  final PageController pageController =
      PageController(initialPage: 0, viewportFraction: 1);

  Widget additionalInfoView(Item item) {
    final hasAdditionInfo = hasAdditionalInfoList.contains(item.subCategory);
    if (!hasAdditionInfo) {
      return Container();
    }
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>?>(
      future: firestoreService.getAdditionalInfo(
          itemId: item.itemid, subCat: item.subCategory),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!.data();
          if (data == null) {
            return Container();
          }
          String additionalInfoText = "";
          final AdditionalInfo additionalInfo =
              additionalInfoFromFirestore(data);

          additionalInfoText = "Condition: ${additionalInfo.condition}";
          additionalInfoText =
              additionalInfoText + "${processAdditionalInfo(additionalInfo)}";
          // print(additionalInfo.toString());

          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Additional Information",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(additionalInfoText),
                Divider(
                  height: 20,
                  thickness: 1.5,
                  color: Colors.grey,
                ),
              ]);
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyItemsController>(
      builder: (controller) {
        final index = controller.items
            .indexWhere((element) => element.itemid == widget.item!.itemid);
        final Item item = controller.items[index];
        return Scaffold(
          appBar: AppBar(
            title: Text("Item Detail: ${item.itemid}"),
            actions: [
              PopupMenuButton<OwnerItemMenu>(
                icon: Icon(Icons.more_vert),
                onSelected: (OwnerItemMenu result) async {
                  switch (result) {
                    case OwnerItemMenu.editItem:
                      Get.to(() => EditItemPage(item: item));
                      break;
                    case OwnerItemMenu.deleteItem:
                      {
                        Get.find<MyItemsController>()
                            .deleteItems(item)
                            .then((value) {
                          if (value) {
                            Get.back();
                          } else {
                            showToast("Delete unsuccessfully");
                          }
                        });
                      }
                      break;
                  }
                },
                itemBuilder: (BuildContext context) =>
                    <PopupMenuEntry<OwnerItemMenu>>[
                  PopupMenuItem(
                    value: OwnerItemMenu.editItem,
                    child: Text("Edit Item"),
                  ),
                  PopupMenuItem(
                    value: OwnerItemMenu.deleteItem,
                    child: Text('Delete Item'),
                  ),
                ],
              ),
              // IconButton(
              //     onPressed: () {
              //
              //     },
              //     icon: Icon(Icons.edit))
            ],
          ),
          body: SafeArea(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    ImagesView(images: item.images),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                      margin: EdgeInsets.only(bottom: 50),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "USD: ${item.price.toString()}",
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Item Detail",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Views ${item.views}",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                          Divider(
                            height: 20,
                            thickness: 1.5,
                            color: Colors.grey,
                          ),
                          Text(
                            "Description",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "${item.description}",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                          Divider(
                            height: 20,
                            thickness: 1.5,
                            color: Colors.grey,
                          ),
                          additionalInfoView(item),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

enum OwnerItemMenu {
  editItem,
  deleteItem,
}
