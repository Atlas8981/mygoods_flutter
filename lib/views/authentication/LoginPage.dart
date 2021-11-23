import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mygoods_flutter/components/TypeTextField.dart';
import 'package:mygoods_flutter/controllers/userController.dart';
import 'package:mygoods_flutter/services/user_service.dart';
import 'package:mygoods_flutter/utils/constant.dart';
import 'package:mygoods_flutter/views/MainActivity.dart';

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
                        SizedBox(
                          height: 40,
                        ),
                      ],
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
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: TextButton(
                            onPressed: forgotPasswordButtonClick,
                            child: Text("Forgot Password".toUpperCase())),
                      )
                    ],
                  )
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
    userService.login(email, password).then((value) {
      if(value == null){
        return;
      }
      showToast("Welcome: $value");
      Get.offAll(()=>MainActivity());
    });
  }

  void forgotPasswordButtonClick() {}
}
//jack_atlas59@yahoo.com