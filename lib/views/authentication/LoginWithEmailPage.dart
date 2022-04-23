import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mygoods_flutter/components/TypeTextField.dart';
import 'package:mygoods_flutter/controllers/HomePageController.dart';
import 'package:mygoods_flutter/controllers/ItemFormController.dart';
import 'package:mygoods_flutter/controllers/UserController.dart';
import 'package:mygoods_flutter/services/AuthenticationService.dart';
import 'package:mygoods_flutter/services/UserService.dart';
import 'package:mygoods_flutter/utils/constant.dart';
import 'package:mygoods_flutter/views/LandingPage.dart';
import 'package:mygoods_flutter/views/authentication/RegisterPage.dart';
import 'package:mygoods_flutter/views/authentication/LoginWithPhoneNumberPage.dart';

class LoginWithEmailPage extends StatefulWidget {
  const LoginWithEmailPage({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginWithEmailPage> createState() => _LoginWithEmailPageState();
}

class _LoginWithEmailPageState extends State<LoginWithEmailPage> {
  final emailCon = TextEditingController(),
      passwordCon = TextEditingController();

  bool isObscure = true;

  final formKey = GlobalKey<FormState>();
  final userService = UserService();
  final authService = AuthenticationService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("login".tr),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "welcomeBack".tr,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Form(
                    key: formKey,
                    child: AutofillGroup(
                      child: Column(
                        children: [
                          TypeTextField(
                            labelText: "email".tr,
                            controller: emailCon,
                            prefixIcon: const Icon(Icons.email_outlined),
                            inputType: TextInputType.emailAddress,
                            autoFillHints: const [AutofillHints.email],
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          TypeTextField(
                            labelText: "password".tr,
                            controller: passwordCon,
                            autoFillHints: const [AutofillHints.password],
                            inputType: TextInputType.visiblePassword,
                            prefixIcon: const Icon(Icons.password),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  isObscure = !isObscure;
                                });
                              },
                              icon: Icon(
                                (isObscure)
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
                            obscureText: isObscure,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      height: 50,
                      child: TextButton(
                        onPressed: forgotPasswordButtonClick,
                        child: Text("forgotPassword".tr),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: signInButtonClick,
                          child: Text("signIn".tr.toUpperCase()),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                   Center(
                    child: Text(
                      "or".tr,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: TextButton(
                          onPressed: signInWithPhoneNumberButtonClick,
                          child:
                              Text("logInWithPhoneNumber".tr),
                        ),
                      ),
                      const SizedBox(
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

    authService.loginWithEmailPassword(email, password).then(
      (credential) async {
        if (credential != null) {
          showToast("Login Success");
          final userData =
              await authService.isUserHaveData(credential.user!.uid);
          if (userData) {
            Get.delete<UserController>();
            Get.lazyPut(() => UserController(), fenix: true);
            Get.delete<ItemFormController>();
            Get.lazyPut(() => ItemFormController(), fenix: true);
            Get.delete<HomePageController>();
            Get.lazyPut(() => HomePageController(), fenix: true);
            Get.offAll(() => const LandingPage());
          } else {
            Get.offAll(
              () => RegisterPage(
                userId: credential.user!.uid,
              ),
            );
          }
        }
      },
    );
  }

  void forgotPasswordButtonClick() {}

  void signInWithPhoneNumberButtonClick() {
    Get.to(() => LoginWithPhoneNumberPage());
  }
}
//jack_atlas59@yahoo.com
