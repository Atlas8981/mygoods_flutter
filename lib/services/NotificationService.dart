import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mygoods_flutter/models/device.dart';
import 'package:rxdart/rxdart.dart';

class NotificationService {
  static final localNotifications = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String>();

  static Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async {

    await localNotifications.show(
      id,
      title,
      body,
      await notificationDetails(),
      payload: payload,
    );
  }

  static Future init({bool initScheduled = false}) async {
    const androidSetting = AndroidInitializationSettings("@mipmap/ic_launcher");
    const iosSetting = IOSInitializationSettings();

    const settings = InitializationSettings(
      android: androidSetting,
      iOS: iosSetting,
    );
    await localNotifications.initialize(
      settings,
      onSelectNotification: (payload) {
        // if(payload!=null){
        onNotifications.add(payload!);
        // }
      },
    );
  }

  static notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'channel id',
        'channel name',
        importance: Importance.max,
        channelShowBadge: true,
        priority: Priority.max,
      ),
      iOS: IOSNotificationDetails(),
    );
  }

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveDeviceToken(
      String userId, List<Device> devices, String? deviceToken) async {
    if (deviceToken != null) {
      var userRef = _db.collection("users").doc(userId);
      await userRef.update({
        "devices": devices.map((e) => e.toJson()).toList(),
      });
    }
  }

  Future<void> setupInteractedMessage() async {
    RemoteMessage? initialMessage = await _fcm.getInitialMessage();

    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void setUpOnMessage() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      NotificationService.showNotification(
        title: '${message.notification!.title}',
        body: "${message.notification!.body}",
        payload: "this is payload",
      );
      if (kDebugMode) {
        print('Got a message whilst in the foreground!');
        print('Message data: ${message.data}');
      }

      if (message.notification != null &&
          message.notification!.android != null) {
        if (kDebugMode) {
          print(
              'Message also contained a notification: ${message.notification!.title}');
          print(message.notification!.title);
        }
      }
    });
  }

  void _handleMessage(RemoteMessage message) {
    if (kDebugMode) {
      print(message.toString());
      print(message.messageId);
    }

    // if (message.data['type'] == 'chat') {
    //   Navigator.pushNamed(context, '/chat',
    //     arguments: (message),
    //   );
    // }
  }
}
