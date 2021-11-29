import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mygoods_flutter/components/TypeTextField.dart';
import 'package:mygoods_flutter/utils/constant.dart';
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
                child: Text("Confirm"))
          ],
        ),
      ),
    );
  }

  final auth = FirebaseAuth.instance;

  Future<void> loginWithPhoneNumber() async {
    if(phoneCon.text.isEmpty){
      return;
    }
    await auth.verifyPhoneNumber(
      phoneNumber: '+855${phoneCon.text.trim()}',
      verificationCompleted: (PhoneAuthCredential credential) async {},
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          showToast('The provided phone number is not valid.');
          print('The provided phone number is not valid.');
        }
        print(e.message);
      },
      codeSent: (String verificationId, int? resendToken) async {
        Get.to(() => VerifyOTPPage(
              verificationId: verificationId,
            ));
        // await auth.signInWithCredential(credential);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }
}
