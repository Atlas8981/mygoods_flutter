import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mygoods_flutter/controllers/BottomNavigationViewController.dart';
import 'package:mygoods_flutter/services/NotificationService.dart';
import 'package:mygoods_flutter/views/user/AboutMePage.dart';
import 'package:mygoods_flutter/views/AddPage.dart';
import 'package:mygoods_flutter/views/category/CategoryPage.dart';
import 'package:mygoods_flutter/views/chat/ChatListPage.dart';

import 'HomePage.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({
    Key? key,
  }) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final bottomNavigationController = Get.put(LandingPageController());
  final notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    NotificationService.init();
    notificationService.setupInteractedMessage();
    notificationService.setUpOnMessage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: bottomNavigationController.tabIndex.value,
          children: const [
            HomePage(),
            CategoryPage(),
            AddPage(),
            ChatListPage(),
            AboutMePage(),
          ],
        ),
      ),
      bottomNavigationBar: buildBottomNavigationMenu(
        context,
        bottomNavigationController,
      ),
    );
  }

  Widget buildBottomNavigationMenu(
      context, LandingPageController landingPageController) {
    return Obx(
      () => NavigationBarTheme(
        data: const NavigationBarThemeData(
          indicatorColor: Colors.blue,
        ),
        child: NavigationBar(
          selectedIndex: landingPageController.tabIndex.value,
          onDestinationSelected: landingPageController.changeTabIndex,
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          destinations:  [
            NavigationDestination(
              selectedIcon: Icon(Icons.home),
              icon: Icon(Icons.home_outlined),
              label: 'home'.tr,
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.format_list_bulleted),
              icon: Icon(Icons.format_list_bulleted_outlined),
              label: 'category'.tr,
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.add_box),
              icon: Icon(Icons.add_box_outlined),
              label: 'sellItem'.tr,
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.chat),
              icon: Icon(Icons.chat_outlined),
              label: 'message'.tr,
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.person),
              icon: Icon(Icons.person_outline),
              label: 'account'.tr,
            ),
          ],
        ),
      ),
    );
  }

}
