import 'dart:async';

import 'package:get/get.dart';
import 'package:mygoods_flutter/models/item/item.dart';
import 'package:mygoods_flutter/services/UserService.dart';

class MyItemsController extends GetxController {
  RxList? items;
  final userService = UserService();

  @override
  void onInit() {
    super.onInit();
    getUserItems();
    // listenForItemChange();
  }

  void getUserItems() {
    userService.getUserItems().then((value) {
      if (value == null) {
        return;
      }
      if (value.isEmpty) {
        items = [].obs;
      }

      items = value.obs;
      update();
    });
  }

  void updateUserItem(Item newItem) {
    if (items == null) {
      return;
    }
    final index =
        items!.indexWhere((element) => element.itemid == newItem.itemid);
    items![index] = newItem;
    update();
  }

  void listenForItemChange() {}
}
