import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:get/get.dart';
import 'package:mygoods_flutter/controllers/UserController.dart';
import 'package:mygoods_flutter/utils/constant.dart';
import 'package:mygoods_flutter/views/MainActivity.dart';
import 'package:mygoods_flutter/views/RegisterPage.dart';
import 'package:sms_autofill/sms_autofill.dart';

class VerifyOTPPage extends StatefulWidget {
  const VerifyOTPPage({
    Key? key,
    this.verificationId,
    this.phoneNumber,
  }) : super(key: key);

  final String? verificationId;
  final String? phoneNumber;

  @override
  _VerifyOTPPageState createState() => _VerifyOTPPageState();
}

class _VerifyOTPPageState extends State<VerifyOTPPage> with CodeAutoFill {
  String? smsCode;
  String? appSignature;

  @override
  void codeUpdated() {
    setState(() {
      smsCode = code;
      // otpCon.text = code!;
      print("$code");
    });
  }

  @override
  void listenForCode({String? smsCodeRegexPattern}) {
    print(smsCodeRegexPattern);
  }

  @override
  void initState() {
    super.initState();
    // listenForCode();

    SmsAutoFill().getAppSignature.then((signature) {
      setState(() {
        appSignature = signature;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    cancel();
  }

  final otpCon = TextEditingController();

  Widget otpTextField() {
    return PinFieldAutoFill(
      decoration: UnderlineDecoration(
        textStyle: TextStyle(fontSize: 16, color: Colors.black),
        colorBuilder: FixedColorBuilder(Colors.blue),
        gapSpace: 24,
        // gapSpaces: [10,24,10,24,10]
      ),
      cursor: Cursor(color: Colors.black, height: 24, enabled: true),
      controller: otpCon,
      codeLength: 6,
      currentCode: smsCode,
      onCodeSubmitted: (code) {
        if (code.length == 6) {
          signInWithPhoneNumber(code);
        }
      },
      onCodeChanged: (code) {
        smsCode = code;
      },
    );
    // return OTPTextField(
    //   length: 6,
    //   width: MediaQuery.of(context).size.width,
    //   textFieldAlignment: MainAxisAlignment.spaceAround,
    //   fieldWidth: 35,
    //   fieldStyle: FieldStyle.underline,
    //   outlineBorderRadius: 15,
    //   style: TextStyle(fontSize: 16),
    //   onCompleted: (pin) {
    //     smsCode = pin;
    //     signInWithPhoneNumber(pin);
    //   },
    //   onChanged: (value) {
    //     smsCode = value;
    //   },
    // );
  }

  final int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 60;

  // late final countdownController = CountdownTimerController(endTime: endTime);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Verify OTP : ${widget.phoneNumber}"),
      ),
      body: Container(
        height: double.maxFinite,
        child: Column(
          children: [
            // Container(
            //   width: double.maxFinite,
            //   height: statusBarHeight,
            //   color: Colors.blue,
            // ),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CountdownTimer(
                    // countdownController: countdownController,
                    // controller: countdownController,
                    endTime: endTime,
                    endWidget: Text(
                      "00:00",
                      style: TextStyle(fontSize: 18),
                    ),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                  // Container(
                  //   padding: EdgeInsets.all(20),
                  //   child: otpTextField(),
                  // ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Tap Below".toUpperCase(),
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  RotatedBox(
                    quarterTurns: 1,
                    child: Icon(Icons.double_arrow),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  // Container(
                  //   padding: EdgeInsets.all(20),
                  //   child: SizedBox(
                  //     height: 40,
                  //     width: double.infinity,
                  //     child: ElevatedButton(
                  //       style: ButtonStyle(),
                  //       onPressed: () {
                  //         FocusScope.of(context).requestFocus(FocusNode());
                  //         if (smsCode == null) {
                  //           showToast("Wrong SMS Code");
                  //           return;
                  //         }
                  //         signInWithPhoneNumber(smsCode!);
                  //         // Get.to(()=>HomePage());
                  //
                  //         // showToast("Verification Complete");
                  //       },
                  //       child: Text(
                  //         "Verify",
                  //         style: TextStyle(fontSize: 14),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  SizedBox(
                    width: double.maxFinite,
                    child: TextButton(
                      onPressed: () {
                        listenForCode();
                      },
                      child: Text(
                        "From Messages \nWaiting for SMS Code",
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black.withOpacity(0.5), height: 1.2),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Color.fromARGB(100, 197, 209, 223)),
                      ),
                    ),
                  )
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
    if (widget.verificationId == null) {
      return;
    }
    final PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: widget.verificationId!,
      smsCode: pin,
    );
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
      print(e.code);
      if (e.code == "invalid-verification-code") {
        showToast("Invalid OTP");
      }
    }
  }
}
