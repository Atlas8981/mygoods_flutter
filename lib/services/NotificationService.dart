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
    // final AndroidInitializationSettings initializationSettingsAndroid =
    // AndroidInitializationSettings('@mipmap/ic_launcher');
    // final IOSInitializationSettings initializationSettingsIOS =
    // IOSInitializationSettings();
    // final MacOSInitializationSettings initializationSettingsMacOS =
    // MacOSInitializationSettings();
    // final InitializationSettings initializationSettings = InitializationSettings(
    //   android: initializationSettingsAndroid,
    //   iOS: initializationSettingsIOS,
    // );
    // await notifications.initialize(initializationSettings,);
    await localNotifications.show(
      id,
      title,
      body,
      await notificationDetails(),
      payload: payload,
    );

    onNotifications.stream.listen((payload) {});
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
        importance: Importance.high,
        channelShowBadge: true,
        priority: Priority.high,
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
