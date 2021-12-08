import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mygoods_flutter/components/TypeTextField.dart';
import 'package:mygoods_flutter/controllers/UserController.dart';
import 'package:mygoods_flutter/services/UserService.dart';
import 'package:mygoods_flutter/views/MainActivity.dart';
import 'package:mygoods_flutter/views/authentication/LoginWithPhoneNumberPage.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailCon = TextEditingController(),
      passwordCon = TextEditingController();

  bool isObscure = true;

  final formKey = GlobalKey<FormState>();
  final userService = UserService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Log In"),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              // color: Colors.red,
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome Back",
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        TypeTextField(
                          labelText: "Email",
                          controller: emailCon,
                          prefixIcon: Icon(Icons.email_outlined),
                          inputType: TextInputType.emailAddress,
                          autoFillHints: [AutofillHints.email],
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        TypeTextField(
                          labelText: "Password",
                          controller: passwordCon,
                          autoFillHints: [AutofillHints.password],
                          inputType: TextInputType.visiblePassword,
                          prefixIcon: Icon(Icons.password),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                isObscure = !isObscure;
                              });
                            },
                            icon: Icon((isObscure)
                                ? Icons.visibility
                                : Icons.visibility_off),
                          ),
                          obscureText: isObscure,
                        ),
                        // SizedBox(
                        //   height: 40,
                        // ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      // width: double.infinity,
                      height: 50,
                      child: TextButton(
                          onPressed: forgotPasswordButtonClick,
                          child: Text("Forgot Password".toUpperCase())),
                    ),
                  ),
                  Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                            onPressed: signInButtonClick,
                            child: Text("Sign In".toUpperCase())),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                  Center(
                    child: Text(
                      "Or",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: TextButton(
                            onPressed: signInWithPhoneNumberButtonClick,
                            child: Text(
                                "Sign In With Phone Number".toUpperCase())),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void signInButtonClick() {
    final String email = emailCon.text.trim();
    final String password = passwordCon.text.trim();

    if (!formKey.currentState!.validate()) {
      return;
    }

    userService.login(email, password).then((value) {
      // if (value == null) {
      //   return;
      // }
      // showToast("Welcome: $value");
      Get.delete<UserController>();
      Get.lazyPut(() => UserController(), fenix: true);
      Get.offAll(() => MainActivity());

    });
  }

  void forgotPasswordButtonClick() {}

  void signInWithPhoneNumberButtonClick() {
    Get.to(() => LoginWithPhoneNumberPage());
  }
}
//jack_atlas59@yahoo.com
