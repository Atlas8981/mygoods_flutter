
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mygoods_flutter/controllers/BottomNavigationViewController.dart';
import 'package:mygoods_flutter/services/NotificationService.dart';
import 'package:mygoods_flutter/views/AboutMePage.dart';
import 'package:mygoods_flutter/views/AddPage.dart';
import 'package:mygoods_flutter/views/CategoryPage.dart';
import 'package:mygoods_flutter/views/chat/ChatListPage.dart';

import 'HomePage.dart';

class MainActivity extends StatefulWidget {
  const MainActivity({
    Key? key,
  }) : super(key: key);

  @override
  _MainActivityState createState() => _MainActivityState();
}

class _MainActivityState extends State<MainActivity> {
  final bottomNavigationController = Get.put(LandingPageController());
  final notificationService = NotificationService();

  Widget buildBottomNavigationMenu(context, landingPageController) {
    return Obx(
      () => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: false,
          showSelectedLabels: true,
          onTap: landingPageController.changeTabIndex,
          currentIndex: landingPageController.tabIndex.value,
          unselectedItemColor: Colors.black54,
          selectedItemColor: Colors.blue,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
              ),
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

  @override
  void initState() {
    super.initState();
    NotificationService.init();
    notificationService.setupInteractedMessage();
    notificationService.setUpOnMessage();
  }
}
