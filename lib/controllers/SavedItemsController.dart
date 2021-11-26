import 'package:get/get.dart';
import 'package:mygoods_flutter/services/UserService.dart';

class SavedItemsController extends GetxController {
  RxList? items;
  final userService = UserService();

  @override
  void onInit() {
    super.onInit();
    getSavedItem();
  }

  void getSavedItem() {
    userService.getUserSavedItem().then((value) {
      if (value == null) {
        return;
      } else if (value.length == 0) {
        items = [].obs;
        update();
        return;
      } else {
        items = value.obs;
        update();
      }
    });
  }
}
