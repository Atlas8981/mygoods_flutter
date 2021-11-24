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
  }

  void getUserItems() {
    userService.getUserItems().then((value) {
      items.addAll(value);
      update();
    });
  }

  Future<bool> deleteItems(Item item) async {
    final isDeleted = await userService.deleteUserItem(item.itemid);
    if(isDeleted){
      items.remove(item);
      update();
    }
    return isDeleted;
  }
}
