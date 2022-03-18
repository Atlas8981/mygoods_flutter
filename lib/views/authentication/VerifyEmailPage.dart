import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mygoods_flutter/components/TypeTextField.dart';
import 'package:mygoods_flutter/services/RegisterService.dart';
import 'package:mygoods_flutter/utils/constant.dart';
import 'package:mygoods_flutter/views/MainActivity.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({
    Key? key,
    required this.email,
    required this.username,
  }) : super(key: key);

  final String email;
  final String username;

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  final otpCon = TextEditingController();

  final registerService = RegisterService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Verify Email"),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Text(
                "You've entered ${widget.email} as the email address for your account. Please verify email address by clicking button below",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                height: 20,
              ),
              TypeTextField(
                labelText: "OTP",
                controller: otpCon,
                inputType: TextInputType.number,
                maxLength: 4,
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: onConfirm,
                  child: Text(
                    "Sign In".toUpperCase(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> onConfirm() async {
    final code = otpCon.text;
    if (code.isEmpty) {
      showToast("Code Empty");
      return;
    }
    final isDone = await registerService.verify(widget.username, code);
    if (isDone) {
      Get.offAll(() => MainActivity());
    } else {
      showToast("Something went wrong");
    }
  }
}
