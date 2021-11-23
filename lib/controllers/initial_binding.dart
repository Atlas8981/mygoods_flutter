import 'package:get/get.dart';
import 'package:mygoods_flutter/controllers/userController.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UserController(), fenix: true);
  }
}
