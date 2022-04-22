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
          // type: BottomNavigationBarType.fixed,
          // showUnselectedLabels: false,
          // showSelectedLabels: true,
          // onTap: landingPageController.changeTabIndex,
          // currentIndex: landingPageController.tabIndex.value,
          // unselectedItemColor: Colors.black54,
          // selectedItemColor: Colors.blue,
          selectedIndex: landingPageController.tabIndex.value,
          onDestinationSelected: landingPageController.changeTabIndex,
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          destinations: const [
            NavigationDestination(
              selectedIcon: Icon(Icons.home),
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.format_list_bulleted),
              icon: Icon(Icons.format_list_bulleted_outlined),
              label: 'Category',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.add_box),
              icon: Icon(Icons.add_box_outlined),
              label: 'Add',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.chat),
              icon: Icon(Icons.chat_outlined),
              label: 'Message',
            ),
            NavigationDestination(
              icon: Icon(Icons.person),
              selectedIcon: Icon(Icons.person_outline),
              label: 'Account',
            ),
          ],
        ),
      ),
    );
  }

  String appTitle(landingPageController) {
    final index = landingPageController.tabIndex.value;
    if (index == 0) {
      return "Home";
    } else if (index == 1) {
      return "Category";
    } else if (index == 2) {
      return "Add Item";
    } else {
      return "Account";
    }
  }
}
