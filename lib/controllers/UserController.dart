import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mygoods_flutter/models/image.dart';
import 'package:mygoods_flutter/models/user.dart';
import 'package:mygoods_flutter/services/UserService.dart';

class UserController extends GetxController {
  Rx<User>? user;

  final userService = UserService();

  @override
  void onInit() {
    super.onInit();
    getUserInfo();
  }

  void getUserInfo() {
    userService.getOwnerInfo().then((value) {
      if (value == null) {
        user = null;
        return;
      }
      user = value.obs;
      update();
    });
  }

  void changeProfilePicture(XFile image) {

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
