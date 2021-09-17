
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mygoods_flutter/controllers/bottomNavigationViewController.dart';
import 'package:mygoods_flutter/views/AccountPage.dart';
import 'package:mygoods_flutter/views/AddPage.dart';
import 'package:mygoods_flutter/views/CategoryPage.dart';

import 'HomePage.dart';

class PageWithBottomNavigation extends StatefulWidget {
  const PageWithBottomNavigation({Key? key}) : super(key: key);

  @override
  _PageWithBottomNavigationState createState() => _PageWithBottomNavigationState();
}

class _PageWithBottomNavigationState extends State<PageWithBottomNavigation> {

  final TextStyle unselectedLabelStyle = TextStyle(
      color: Colors.white.withOpacity(0.5),
      fontWeight: FontWeight.w500,
      fontSize: 12);
  final TextStyle selectedLabelStyle = TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 12);
  final bottomNavigationController = Get.put(LandingPageController());
  buildBottomNavigationMenu(context, landingPageController) {
    return Obx(() =>
        MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: SizedBox(
              height: 54,
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                showUnselectedLabels: false,
                showSelectedLabels: true,
                onTap: landingPageController.changeTabIndex,
                currentIndex: landingPageController.tabIndex.value,
                unselectedItemColor: Colors.black54,
                selectedItemColor: Colors.blue,
                unselectedLabelStyle: unselectedLabelStyle,
                selectedLabelStyle: selectedLabelStyle,
                items: [
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
                    icon: Icon(Icons.person_outline),
                    label: 'Account',
                  ),
                ],
              ),
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyGoods Flutter'),
      ),
      body: Obx(() => IndexedStack(
        index: bottomNavigationController.tabIndex.value,
        children: [
          HomePage(),
          CategoryPage(),
          AddPage(),
          AccountPage(),
        ],
      )),
      bottomNavigationBar: buildBottomNavigationMenu(context,bottomNavigationController),
      // bottomNavigationBar: BottomNavigationBar(
      //   type: BottomNavigationBarType.fixed,
      //   showUnselectedLabels: false,
      //   unselectedItemColor: Colors.grey,
      //   items:  [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: 'Home',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.list_outlined),
      //       label: 'Category',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.add_box_outlined),
      //       label: 'Add',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.person),
      //       label: 'Account',
      //     ),
      //   ],
      //   currentIndex: _selectedIndex,
      //   selectedItemColor: Colors.blue[800],
      //   onTap: (index) {
      //     setState(() {
      //       _selectedIndex = index;
      //     });
      //   },
      // ),
    );
  }
}
