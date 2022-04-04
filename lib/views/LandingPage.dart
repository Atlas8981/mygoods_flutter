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
        containerHeight: Get.height/12,
        showElevation: true,
        items: [
          BottomNavyBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
            activeColor: Colors.blue,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.format_list_bulleted),
            title: Text('Category'),
            activeColor: Colors.amber,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.add_box_outlined),
            title: Text('Add'),
            activeColor: Colors.red,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.chat_outlined),
            title: Text('Message'),
            activeColor: Colors.indigo,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.person_outline),
            title: Text('Account'),
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
