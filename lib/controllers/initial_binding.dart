import 'package:get/get.dart';
import 'package:mygoods_flutter/controllers/AuthenticationController.dart';
import 'package:mygoods_flutter/controllers/UserController.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => UserController(),
      fenix: true,
    );
    Get.put(AuthenticationController(), permanent: true);
  }
}
