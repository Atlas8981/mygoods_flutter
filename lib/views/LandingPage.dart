
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

  Widget buildBottomNavigationMenu(context, landingPageController) {
    return Obx(
      () => BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: false,
        showSelectedLabels: true,
        onTap: landingPageController.changeTabIndex,
        currentIndex: landingPageController.tabIndex.value,
        unselectedItemColor: Colors.black54,
        selectedItemColor: Colors.blue,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.format_list_bulleted),
            label: 'Category',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_outlined),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_outlined),
            label: 'Message',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Account',
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
