import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mygoods_flutter/components/ImageViews.dart';
import 'package:mygoods_flutter/controllers/MyItemsController.dart';
import 'package:mygoods_flutter/models/additionalInfo.dart';
import 'package:mygoods_flutter/models/item.dart';
import 'package:mygoods_flutter/services/ItemService.dart';
import 'package:mygoods_flutter/utils/constant.dart';
import 'package:mygoods_flutter/views/item/EditItemPage.dart';

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
  final firestoreService = ItemService();
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
              const Text(
                "Additional Information",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(additionalInfoText),
              const Divider(
                height: 20,
                thickness: 1.5,
                color: Colors.grey,
              ),
            ],
          );
        } else {
          return const Center(
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
        final index = controller.items!
            .indexWhere((element) => element.itemid == widget.item!.itemid);
        final Item item = controller.items![index];
        return Scaffold(
          appBar: AppBar(
            title: Text("Item Detail: ${item.itemid}"),
            actions: [
              PopupMenuButton<OwnerItemMenu>(
                icon: const Icon(Icons.more_vert),
                onSelected: (OwnerItemMenu result) async {
                  switch (result) {
                    case OwnerItemMenu.editItem:
                      Get.to(() => EditItemPage(item: item));
                      break;
                    case OwnerItemMenu.deleteItem:
                      {
                        Get.find<MyItemsController>().deleteItems(item).then(
                          (value) {
                            if (value) {
                              Get.back();
                            } else {
                              showToast("Delete unsuccessfully");
                            }
                          },
                        );
                      }
                      break;
                  }
                },
                itemBuilder: (BuildContext context) =>
                    <PopupMenuEntry<OwnerItemMenu>>[
                  const PopupMenuItem(
                    value: OwnerItemMenu.editItem,
                    child: Text("Edit Item"),
                  ),
                  const PopupMenuItem(
                    value: OwnerItemMenu.deleteItem,
                    child: Text('Delete Item'),
                  ),
                ],
              ),
            ],
          ),
          body: SafeArea(
            child: SizedBox(
              width: double.maxFinite,
              height: double.maxFinite,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    ImagesView(images: item.images),
                    Container(
                      width: double.infinity,
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, top: 20),
                      margin: const EdgeInsets.only(bottom: 50),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            "USD: ${item.price.toString()}",
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            "Item Detail",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Views ${item.views}",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Divider(
                            height: 20,
                            thickness: 1.5,
                            color: Colors.grey,
                          ),
                          const Text(
                            "Description",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            item.description,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Divider(
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
