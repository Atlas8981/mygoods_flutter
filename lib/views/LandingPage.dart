import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mygoods_flutter/controllers/BottomNavigationViewController.dart';
import 'package:mygoods_flutter/services/NotificationService.dart';
import 'package:mygoods_flutter/views/AboutMePage.dart';
import 'package:mygoods_flutter/views/AddPage.dart';
import 'package:mygoods_flutter/views/CategoryPage.dart';
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
          children: [
            const HomePage(),
            CategoryPage(),
            const AddPage(),
            const ChatListPage(),
            const AboutMePage(),
          ],
        ),
      ),
      bottomNavigationBar: buildBottomNavigationMenu(
        context,
        bottomNavigationController,
      ),
    );
  }

  Widget buildBottomNavigationMenu(context, landingPageController) {
    return Obx(
      () => BottomNavyBar(
        // type: BottomNavigationBarType.fixed,
        // showUnselectedLabels: false,
        // showSelectedLabels: true,
        // onTap: landingPageController.changeTabIndex,
        // currentIndex: landingPageController.tabIndex.value,
        // unselectedItemColor: Colors.black54,
        // selectedItemColor: Colors.blue,
        selectedIndex: landingPageController.tabIndex.value,
        onItemSelected: landingPageController.changeTabIndex,
        itemCornerRadius: 8,
        containerHeight: Get.height / 12,
        showElevation: true,
        items: [
          BottomNavyBarItem(
            icon: const Icon(Icons.home),
            title: const Text('Home'),
            activeColor: Colors.blue,
          ),
          BottomNavyBarItem(
            icon: const Icon(Icons.format_list_bulleted),
            title: const Text('Category'),
            activeColor: Colors.amber,
          ),
          BottomNavyBarItem(
            icon: const Icon(Icons.add_box_outlined),
            title: const Text('Add'),
            activeColor: Colors.red,
          ),
          BottomNavyBarItem(
            icon: const Icon(Icons.chat_outlined),
            title: const Text('Message'),
            activeColor: Colors.indigo,
          ),
          BottomNavyBarItem(
            icon: const Icon(Icons.person_outline),
            title: const Text('Account'),
            activeColor: Colors.cyan,
          ),
        ],
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
