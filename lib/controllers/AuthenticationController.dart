import 'package:get/get.dart';
import 'package:mygoods_flutter/models/token_response.dart';

class AuthenticationController extends GetxController {
  Rx<TokenResponse>? tokenRes;

  void setToken(TokenResponse tokenResponse) {
    tokenRes = tokenResponse.obs;
    update();
  }
}
