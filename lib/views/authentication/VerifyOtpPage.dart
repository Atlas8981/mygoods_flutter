import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:get/get.dart';
import 'package:mygoods_flutter/controllers/ItemFormController.dart';
import 'package:mygoods_flutter/controllers/UserController.dart';
import 'package:mygoods_flutter/services/UserService.dart';
import 'package:mygoods_flutter/utils/constant.dart';
import 'package:mygoods_flutter/views/MainActivity.dart';
import 'package:mygoods_flutter/views/authentication/RegisterPage.dart';
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
  late String? verificationId = widget.verificationId;

  final otpCon = TextEditingController();

  String messageText = "Waiting for SMS Code";
  final int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 60;
  bool isTimerEnd = false;
  final auth = FirebaseAuth.instance;

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

  @override
  void codeUpdated() {
    setState(() {
      smsCode = code;
      messageText = "$code";
      print(code);
    });
  }

  @override
  void initState() {
    super.initState();
    listenForCode();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Verify OTP : ${widget.phoneNumber}"),
      ),
      body: SizedBox(
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
                    onEnd: () {
                      isTimerEnd = true;
                    },
                  ),
                  // Container(
                  //   padding: EdgeInsets.all(20),
                  //   child: otpTextField(),
                  // ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      resendCode();
                    },
                    child: Text("Resend Code"),
                  ),
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
                        if (smsCode != null) {
                          signInWithPhoneNumber(smsCode!);
                        } else {
                          showToast("No Code");
                        }
                      },
                      child: Text(
                        "From Message\n$messageText",
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

  final userService = UserService();

  Future<void> signInWithPhoneNumber(String pin) async {
    if (verificationId == null) {
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
        userService.isUserHaveData(authCredential.user!.uid).then((value) {
          if (value) {
            Get.delete<UserController>();
            Get.lazyPut(() => UserController(), fenix: true);
            Get.delete<ItemFormController>();
            Get.lazyPut(() => ItemFormController(), fenix: true);
            Get.offAll(() => MainActivity());
          } else {
            Get.offAll(
              () => RegisterPage(
                userId: authCredential.user!.uid,
                phoneNumber: authCredential.user!.phoneNumber!,
              ),
            );
          }
        });
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

  Future<void> resendCode() async {
    if (isTimerEnd) {
      isTimerEnd = false;
      await auth.verifyPhoneNumber(
        phoneNumber: '+855${widget.phoneNumber}',
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
        codeSent: (String vId, int? resendToken) async {
          verificationId = vId;
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
        timeout: Duration(seconds: 60),
      );
    }
  }
}
