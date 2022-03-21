import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mygoods_flutter/components/TypeTextField.dart';
import 'package:mygoods_flutter/utils/constant.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({Key? key}) : super(key: key);

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  TextEditingController currentPasswordController = TextEditingController(),
      newPasswordController = TextEditingController(),
      confirmNewPasswordController = TextEditingController();

  final resetPasswordFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("resetPassword".tr),
        actions: [
          IconButton(
            onPressed: () {
              if (!resetPasswordFormKey.currentState!.validate()) {
                return;
              }
              if (newPasswordController.text !=
                  confirmNewPasswordController.text) {
                showToast('passwordNotMatch'.tr);
                return;
              }
              Get.back();
            },
            icon: const Icon(Icons.check),
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: resetPasswordFormKey,
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "resetPasswordTitle".tr,
                  // "Something",
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TypeTextField(
                controller: currentPasswordController,
                prefixIcon: const Icon(Icons.password),
                labelText: "currentPassword".tr,
                obscureText: true,
              ),
              const Padding(padding: EdgeInsets.only(right: 10)),
              const SizedBox(
                height: 20,
              ),
              TypeTextField(
                controller: newPasswordController,
                prefixIcon: const Icon(Icons.password),
                labelText: "newPassword".tr,
                obscureText: true,
              ),
              const SizedBox(
                height: 20,
              ),
              TypeTextField(
                controller: confirmNewPasswordController,
                prefixIcon: const Icon(Icons.password),
                labelText: "confirmNewPassword".tr,
                obscureText: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
