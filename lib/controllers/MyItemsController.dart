import 'dart:async';

import 'package:get/get.dart';
import 'package:mygoods_flutter/models/my_item.dart';
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

  void updateUserItem(MyItem newItem) {
    if (items == null) {
      return;
    }
    final index =
        items!.indexWhere((element) => element.itemid == newItem.itemid);
    items![index] = newItem;
    update();
  }

  void listenForItemChange() {
    if (items == null) {
      return;
    }
    userService.listenForUserItemChange().listen((value) {
      final tempList = [];
      for (int i = 0; i < value.docs.length; i++) {
        if (value.docs[i].exists) {
          MyItem item = MyItem.fromJson(value.docs[i].data());
          tempList.add(item);
        }
      }
      items!.clear();
      items!.addAll(tempList);
      update();
    });
  }

  Future<bool> deleteItems(MyItem item) async {
    if (items == null) {
      return false;
    }
    final isDeleted = await userService.deleteUserItem(item.itemid);
    if (isDeleted) {
      items!.remove(item);
      update();
    }
    return isDeleted;
  }
}
