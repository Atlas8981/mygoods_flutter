import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mygoods_flutter/components/TypeTextField.dart';
import 'package:mygoods_flutter/controllers/ItemFormController.dart';
import 'package:mygoods_flutter/controllers/UserController.dart';
import 'package:mygoods_flutter/services/AuthenticationService.dart';
import 'package:mygoods_flutter/utils/constant.dart';
import 'package:mygoods_flutter/views/MainActivity.dart';
import 'package:mygoods_flutter/views/RegisterPage.dart';
import 'package:mygoods_flutter/views/authentication/VerifyOtpPage.dart';

class LoginWithPhoneNumberPage extends StatelessWidget {
  LoginWithPhoneNumberPage({
    Key? key,
  }) : super(key: key);

  final phoneCon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login With Phone Number"),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TypeTextField(
              labelText: "Phone Number",
              controller: phoneCon,
              inputType: TextInputType.phone,
              prefix: "0",
              maxLength: 9,
              buildCounter: (
                context, {
                required currentLength,
                required isFocused,
                maxLength,
              }) {
                return Text(
                  '${currentLength + 1}/${maxLength! + 1}',
                  semanticsLabel: 'character count',
                  style: const TextStyle(fontSize: 12, height: 1),
                );
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Field Empty";
                }
                if (!GetUtils.isPhoneNumber("0$value")) {
                  return "Wrong Phone Format";
                }
                return null;
              },
            ),
            TextButton(
              onPressed: () {
                loginWithPhoneNumber();
              },
              child: const Text("Confirm"),
            )
          ],
        ),
      ),
    );
  }

  final auth = FirebaseAuth.instance;

  Future<void> loginWithPhoneNumber() async {
    if (phoneCon.text.isEmpty) {
      showToast("Empty Phone Number");
      return;
    }
    final String phoneNumber = phoneCon.text.trim();
    await auth.verifyPhoneNumber(
      phoneNumber: '+855$phoneNumber',
      verificationCompleted: (PhoneAuthCredential credential) async {
        // if(GetPlatform.isAndroid){
        //   signInWithCredential(credential);
        // }
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          showToast('Invalid Phone Number');
        } else if (e.code == "too-many-requests") {
          showToast("Too Many Request");
        }
        if (kDebugMode) {
          print(e.message);
          print(e.code);
        }
      },
      codeSent: (String verificationId, int? resendToken) async {
        Get.to(
          () => VerifyOTPPage(
            verificationId: verificationId,
            phoneNumber: phoneNumber,
          ),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
      timeout: const Duration(seconds: 60),
    );
  }

  final authService = AuthenticationService();

  Future<void> signInWithCredential(credential) async {
    final authCredential = await auth.signInWithCredential(credential);
    if (authCredential.user != null) {
      showToast("Login Success");
      authService.isUserHaveData(authCredential.user!.uid).then((value) {
        if (value) {
          Get.delete<UserController>();
          Get.lazyPut(() => UserController(), fenix: true);
          Get.delete<ItemFormController>();
          Get.lazyPut(() => ItemFormController(), fenix: true);
          Get.offAll(() => const MainActivity());
        } else {
          Get.offAll(
            () => RegisterPage(
              userId: credential.user!.uid,
              phoneNumber: authCredential.user!.phoneNumber!,
            ),
          );
        }
      });
    } else {
      showToast("Login Failed");
    }
  }
}
