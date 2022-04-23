import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mygoods_flutter/components/CustomAlertDialog.dart';
import 'package:mygoods_flutter/controllers/MyItemsController.dart';
import 'package:mygoods_flutter/models/item.dart';
import 'package:mygoods_flutter/services/ItemService.dart';
import 'package:mygoods_flutter/services/UserService.dart';
import 'package:mygoods_flutter/views/cells/OwnerItemRow.dart';
import 'package:mygoods_flutter/views/item/EditItemPage.dart';
import 'package:mygoods_flutter/views/user/MyItemDetailPage.dart';

class MyItemsPage extends StatelessWidget {
  MyItemsPage({Key? key}) : super(key: key);

  final userService = UserService();
  final myItemController = Get.put(MyItemsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Item(s)"),
      ),
      body: SafeArea(
        child: GetBuilder<MyItemsController>(
          init: myItemController,
          builder: (controller) {
            if (controller.items == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final List<Item> items = controller.items!.cast();
            if (items.isEmpty) {
              return const Center(
                child: Text("You have no items"),
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
      title: "Are you sure you want to delete this item ?",
      onConfirm: () {
        myItemController.deleteItems(item);
        Get.back();
      },
    );
  }
}


