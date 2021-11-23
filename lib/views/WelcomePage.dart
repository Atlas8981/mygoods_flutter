import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:mygoods_flutter/utils/constant.dart';
import 'package:mygoods_flutter/views/authentication/LoginPage.dart';
import 'package:mygoods_flutter/views/authentication/SignUpPage.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome"),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "${imageDir}appicon.png",
                height: 125,
                width: 125,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Millions Little Things. \nMillions of Buyer.",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 24, height: 1.5),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                          onPressed: signUpButtonClick,
                          child: Text("Sign Up".toUpperCase())),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                          onPressed: loginButtonClick,
                          child: Text("Log In".toUpperCase())),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void signUpButtonClick() {
    Get.to(SignUpPage());
  }

  void loginButtonClick() {
    Get.to(LoginPage());
  }
}
