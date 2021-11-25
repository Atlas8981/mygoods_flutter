import 'dart:async';

import 'package:get/get.dart';
import 'package:mygoods_flutter/models/item.dart';
import 'package:mygoods_flutter/services/user_service.dart';

class MyItemsController extends GetxController {
  final items = [].obs;
  final userService = UserService();

  @override
  void onInit() {
    super.onInit();
    getUserItems();
    listenForItemChange();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getUserItems() {
    userService.getUserItems().then((value) {
      if (value == null) {
        return;
      }
      items.addAll(value);
      update();
    });
  }

  void listenForItemChange() {
    userService.listenForUserItemChange().listen((value) {
      final tempList = [];
      for (int i = 0; i < value.docs.length; i++) {
        if (value.docs[i].exists) {
          Item item = Item.fromJson(value.docs[i].data());
          tempList.add(item);
        }
      }
      items.clear();
      items.addAll(tempList);
      update();
    });
  }

  Future<bool> deleteItems(Item item) async {
    final isDeleted = await userService.deleteUserItem(item.itemid);
    if (isDeleted) {
      items.remove(item);
      update();
    }
    return isDeleted;
  }
}
