import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mygoods_flutter/models/device.dart';
import 'package:mygoods_flutter/models/image.dart';
import 'package:mygoods_flutter/models/user.dart';
import 'package:mygoods_flutter/services/NotificationService.dart';
import 'package:mygoods_flutter/services/UserService.dart';

class UserController extends GetxController {
  Rx<User>? user;

  final userService = UserService();

  @override
  void onInit() {
    super.onInit();
    getUserInfo();
  }

  Future<void> getUserInfo() async {
    final User? tempUser = await userService.getOwnerInfo();

    if (tempUser == null) {
      user = null;
      return;
    }
    user = tempUser.obs;
    checkDeviceToken();
    update();
  }

  final notificationService = NotificationService();
  final fcm = FirebaseMessaging.instance;

  Future<void> checkDeviceToken() async {
    List<Device>? devices = user?.value.devices ?? [];
    final String? deviceToken = await fcm.getToken();
    final firestoreTokens = devices.map((e) => e.token).toList();

    if ((devices.isEmpty || !firestoreTokens.contains(deviceToken)) &&
        deviceToken != null) {
      devices.add(
        Device(
          platform: Platform.operatingSystem,
          token: deviceToken,
          createdAt: DateTime.now(),
        ),
      );
      await notificationService.saveDeviceToken(
        user!.value.userId,
        devices,
        deviceToken,
      );
    }
  }

  void changeProfilePicture(XFile image) {
    user!.value.image = Image(imageName: "pending", imageUrl: "");
    update();
    userService
        .updateUserImage(
      File(image.path),
      user!.value,
    )
        .then((value) {
      user!.value.image = value;
      update();
    });
  }

  Future<bool> updateUserInfo(User newUserInfo) async {
    final response = await userService.updateUserInfo(newUserInfo);
    if (response != null) {
      user!.value = response;
      update();
      return true;
    } else {
      return false;
    }
  }
}
