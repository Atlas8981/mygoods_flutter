import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mygoods_flutter/components/TypeTextField.dart';
import 'package:mygoods_flutter/utils/constant.dart';
import 'package:mygoods_flutter/views/authentication/VerifyOtpPage.dart';

class LoginWithPhoneNumberPage extends StatefulWidget {
  const LoginWithPhoneNumberPage({Key? key}) : super(key: key);

  @override
  State<LoginWithPhoneNumberPage> createState() =>
      _LoginWithPhoneNumberPageState();
}

class _LoginWithPhoneNumberPageState extends State<LoginWithPhoneNumberPage> {
  final phoneCon = TextEditingController();
  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login With Phone Number"),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Visibility(
              visible: isVisible,
              child: CircularProgressIndicator(),
            ),
            SizedBox(
              height: 20,
            ),
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
                //TODO: Uncomment
                // setState(() {
                //   isVisible = !isVisible;
                // });
                Get.to(() => VerifyOTPPage());
                // loginWithPhoneNumber();
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
      verificationCompleted: (PhoneAuthCredential credential) {
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
      codeSent: (String verificationId, int? resendToken) {
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
}
