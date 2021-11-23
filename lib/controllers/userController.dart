import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mygoods_flutter/models/user.dart';
import 'package:mygoods_flutter/services/user_service.dart';

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
      user = value!.obs;
    });
  }

  void changeProfilePicture(XFile image) {

    userService.updateUserImage(File(image.path)).then((value) {
      user!.value.image = value;
      update();
    });
  }
}
