import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mygoods_flutter/views/WelcomePage.dart';

class LandingPageController extends GetxController {
  var tabIndex = 0.obs;

  void changeTabIndex(int index) {
    int preTabIndex = tabIndex.value;
    tabIndex.value = index;
    if (index == 2 || index == 3) {
      checkLogin(preTabIndex);
    }
  }

  Future<void> checkLogin(int preTabIndex) async {
    final auth = FirebaseAuth.instance;
    if (auth.currentUser == null) {
      final bool isLogin = await Get.to(() => WelcomePage());
      if (!isLogin) {
        Get.find<LandingPageController>().changeTabIndex(preTabIndex);
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void dispose() {
    super.dispose();
  }
}