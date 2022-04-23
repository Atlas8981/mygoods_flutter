import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mygoods_flutter/utils/constant.dart';
import 'package:mygoods_flutter/views/authentication/LoginWithEmailPage.dart';
import 'package:mygoods_flutter/views/authentication/LoginWithPhoneNumberPage.dart';
import 'package:mygoods_flutter/views/authentication/SignUpPage.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.back(result: false);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("welcome".tr),
        ),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "${imageDir}appicon.png",
                  height: 125,
                  width: 125,
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Millions Little Things. \nMillions of Buyer.",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: signUpButtonClick,
                          child: Text("signUp".tr),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: loginButtonClick,
                          child: Text("logInWithEmail".tr),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: TextButton(
                          onPressed: loginWithPhoneButtonClick,
                          child: Text("logInWithPhoneNumber".tr),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void signUpButtonClick() {
    Get.to(() => SignUpPage());
  }

  void loginButtonClick() {
    Get.to(() => const LoginWithEmailPage());
  }

  void loginWithPhoneButtonClick() {
    Get.to(() => LoginWithPhoneNumberPage());
  }
}
