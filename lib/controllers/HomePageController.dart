import 'package:get/get.dart';
import 'package:mygoods_flutter/services/HomePageService.dart';

class HomePageController extends GetxController {
  RxList? recentViewItem;

  @override
  void onInit() {
    super.onInit();
    getRecentViewItem();
  }

  final homePageService = HomePageService();

  void getRecentViewItem() {
    homePageService.getRecentViewItems().then((value) {
      if (value.length == 0) {
        recentViewItem = [].obs;
      } else {
        recentViewItem = value.obs;
      }
      update();
    });
  }
}
