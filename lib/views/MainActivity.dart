import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
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
  const MainActivity({Key? key}) : super(key: key);

  @override
  _MainActivityState createState() => _MainActivityState();
}

class _MainActivityState extends State<MainActivity> {
  final bottomNavigationController = Get.put(LandingPageController());

  buildBottomNavigationMenu(context, landingPageController) {
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
      body: Obx(() => IndexedStack(
            index: bottomNavigationController.tabIndex.value,
            children: [
              HomePage(),
              CategoryPage(),
              AddPage(),
              ChatListPage(),
              AboutMePage(),
            ],
          )),
      bottomNavigationBar: buildBottomNavigationMenu(
        context,
        bottomNavigationController,
      ),
    );
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
    setupInteractedMessage();
  }

  late StreamSubscription iosSubscription;
  @override
  void initState() {
    super.initState();
    if (Platform.isIOS) {
      // iosSubscription = _fcm.requestPermission();
      // _fcm.requestPermission(());
    } else {
      saveDeviceToken();
    }

    NotificationService.init();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null &&
          message.notification!.android != null) {
        print(
            'Message also contained a notification: ${message.notification!.title}');
        print(message.notification!.title);
        NotificationService.showNotification(
            title: '${message.notification!.title}',
            body: "${message.notification!.body}",
            payload: "this is payload");
      }
    });
  }

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;


  Future<void> saveDeviceToken() async {
    String? fcmToken = await _fcm.getToken();
    if (fcmToken != null) {
      //TODO:Save User device token
      // var tokenRef = _db.collection("devices").doc(fcmToken);
      // await tokenRef.set({
      //   'token': fcmToken,
      //   'createdAt': FieldValue.serverTimestamp(),
      //   'platform': Platform.operatingSystem
      // });
    }
  }

  Future<void> setupInteractedMessage() async {
    RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    print(message.toString());
    print(message.messageId);
    // if (message.data['type'] == 'chat') {
    //   Navigator.pushNamed(context, '/chat',
    //     arguments: (message),
    //   );
    // }
  }

}
