import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mygoods_flutter/components/TypeTextField.dart';
import 'package:mygoods_flutter/controllers/ItemFormController.dart';
import 'package:mygoods_flutter/controllers/UserController.dart';
import 'package:mygoods_flutter/utils/constant.dart';
import 'package:mygoods_flutter/views/MainActivity.dart';
import 'package:mygoods_flutter/views/RegisterPage.dart';
import 'package:mygoods_flutter/views/authentication/VerifyOtpPage.dart';

class LoginWithPhoneNumberPage extends StatelessWidget {
  LoginWithPhoneNumberPage({Key? key}) : super(key: key);

  final phoneCon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login With Phone Number"),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        // color: Colors.red,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TypeTextField(
              labelText: "Phone Number",
              controller: phoneCon,
              inputType: TextInputType.phone,
              prefix: "0",
              maxLength: 9,
              buildCounter: (context,
                  {required currentLength, required isFocused, maxLength}) {
                return Text(
                  '${currentLength + 1}/${maxLength! + 1}',
                  semanticsLabel: 'character count',
                  style: TextStyle(fontSize: 12, height: 1),
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
              child: Text("Confirm"),
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
        print(e.message);
        print(e.code);
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
      timeout: Duration(seconds: 60),
    );
  }

  Future<void> signInWithCredential(credential) async {
    final authCredential = await auth.signInWithCredential(credential);
    if (authCredential.user != null) {
      showToast("Login Success");
      final response = await FirebaseFirestore.instance
          .collection("$userCollection")
          .doc(authCredential.user!.uid)
          .get();
      if (response.exists &&
          response.data() != null &&
          response.data()!.isNotEmpty) {
        Get.delete<UserController>();
        Get.lazyPut(() => UserController(), fenix: true);
        Get.delete<ItemFormController>();
        Get.lazyPut(() => ItemFormController(), fenix: true);
        Get.offAll(() => MainActivity());
      } else {
        Get.offAll(() => RegisterPage(
              userId: authCredential.user!.uid,
              phoneNumber: authCredential.user!.phoneNumber!,
            ));
      }
    } else {
      showToast("Login Failed");
    }
  }
}
