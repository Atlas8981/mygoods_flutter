import 'package:get/get.dart';
import 'package:mygoods_flutter/services/HomePageService.dart';

class HomePageController extends GetxController {
  RxList? recentViewItems;
  RxList? trendingItems;
  // RxList? recommendationItems;
  final homePageService = HomePageService();
  @override
  void onInit() {
    super.onInit();
    getRecentViewItems();
    getTrendingItems();
  }
  void getTrendingItems() {
    homePageService.getTrendingItems().then((value) {
      if (value.length == 0) {
        trendingItems = [].obs;
      } else {
        trendingItems = value.obs;
      }
      update();
    });
  }

  void getRecentViewItems() {
    homePageService.getRecentViewItems().then((value) {
      if (value.length == 0) {
        recentViewItems = [].obs;
      } else {
        recentViewItems = value.obs;
      }
      update();
    });
  }

  // void getRecommendationItem() {
    // homePageService.getRecentViewItems().then((value) {
    //   if (value.length == 0) {
    //     recentViewItems = [].obs;
    //   } else {
    //     recentViewItems = value.obs;
    //   }
    //   update();
    // });
  // }
}
