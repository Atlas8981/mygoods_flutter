import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mygoods_flutter/controllers/UserController.dart';
import 'package:mygoods_flutter/utils/constant.dart';
import 'package:mygoods_flutter/views/MainActivity.dart';
import 'package:mygoods_flutter/views/RegisterPage.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';

class VerifyOTPPage extends StatefulWidget {
  const VerifyOTPPage({Key? key, required this.verificationId})
      : super(key: key);

  final String verificationId;

  @override
  _VerifyOTPPageState createState() => _VerifyOTPPageState();
}

class _VerifyOTPPageState extends State<VerifyOTPPage> {
  String? smsCode;

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      body: Container(
        height: double.maxFinite,
        child: Column(
          children: [
            Container(
              width: double.maxFinite,
              height: statusBarHeight,
              color: Colors.blue,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    child: OTPTextField(
                      length: 6,
                      width: MediaQuery.of(context).size.width,
                      textFieldAlignment: MainAxisAlignment.spaceAround,
                      fieldWidth: 35,
                      fieldStyle: FieldStyle.underline,
                      outlineBorderRadius: 15,
                      style: TextStyle(fontSize: 16),
                      onCompleted: (pin) {
                        // Get.to(()=>HomePage());
                        smsCode = pin;
                        signInWithPhoneNumber(pin);
                      },
                      onChanged: (value) {
                        smsCode = value;
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    child: SizedBox(
                      height: 40,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ButtonStyle(),
                        onPressed: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          if (smsCode == null) {
                            showToast("Wrong SMS Code");
                            return;
                          }
                          signInWithPhoneNumber(smsCode!);
                          // Get.to(()=>HomePage());

                          // showToast("Verification Complete");
                        },
                        child: Text(
                          "Verify",
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  final auth = FirebaseAuth.instance;

  Future<void> signInWithPhoneNumber(String pin) async {
    final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId, smsCode: pin);
    try {
      final authCredential = await auth.signInWithCredential(credential);
      if (authCredential.user != null) {
        showToast("Login Success");
        final response = await FirebaseFirestore.instance
            .collection("$userCollection")
            .doc(authCredential.user!.uid)
            .get();
        if (response.exists) {
          Get.delete<UserController>();
          Get.lazyPut(() => UserController(), fenix: true);
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
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }
}
