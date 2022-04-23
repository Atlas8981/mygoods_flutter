import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mygoods_flutter/components/CustomAlertDialog.dart';
import 'package:mygoods_flutter/components/CustomErrorWidget.dart';
import 'package:mygoods_flutter/components/LoadingWidget.dart';
import 'package:mygoods_flutter/controllers/MyItemsController.dart';
import 'package:mygoods_flutter/models/item.dart';
import 'package:mygoods_flutter/services/ItemService.dart';
import 'package:mygoods_flutter/services/UserService.dart';
import 'package:mygoods_flutter/views/cells/OwnerItemRow.dart';
import 'package:mygoods_flutter/views/item/EditItemPage.dart';
import 'package:mygoods_flutter/views/user/MyItemDetailPage.dart';

class MyItemsPage extends StatefulWidget {
  const MyItemsPage({Key? key}) : super(key: key);

  @override
  State<MyItemsPage> createState() => _MyItemsPageState();
}

class _MyItemsPageState extends State<MyItemsPage> {
  final userService = UserService();

  final myItemController = Get.put(MyItemsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("myItem".tr),
      ),
      body: SafeArea(
        child: GetBuilder<MyItemsController>(
          init: myItemController,
          builder: (controller) {
            if (controller.items == null) {
              return const LoadingWidget();
            }

            final List<Item> items = controller.items!.cast();
            if (items.isEmpty) {
              return CustomErrorWidget(
                text: "noItems".tr,
              );
            }
            return Container(
              padding: const EdgeInsets.only(
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

  void onClickEditItem(Item item) {
    Get.to(
      () => EditItemPage(
        item: item,
      ),
    );
  }

  void onClickDeleteItem(context, Item item) {
    showCustomDialog(
      context,
      title: "deleteTitle".tr,
      onConfirm: () {
        myItemController.deleteItems(item);
        Get.back();
      },
    );
  }
}
