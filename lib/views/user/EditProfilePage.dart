import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mygoods_flutter/components/TypeTextField.dart';
import 'package:mygoods_flutter/controllers/UserController.dart';
import 'package:mygoods_flutter/models/user.dart';
import 'package:mygoods_flutter/services/UserService.dart';
import 'package:mygoods_flutter/utils/constant.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User? user;

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final firstnameCon = TextEditingController(),
      lastnameCon = TextEditingController(),
      usernameCon = TextEditingController(),
      addressCon = TextEditingController(),
      phoneNumberCon = TextEditingController();
  bool isVisible = false;
  final formKey = GlobalKey<FormState>();

  final userService = UserService();

  @override
  void initState() {
    super.initState();
    setDataIntoViews();
  }

  late final User currentUser = widget.user!;

  void setDataIntoViews() {
    firstnameCon.text = currentUser.firstname;
    lastnameCon.text = currentUser.lastname;
    usernameCon.text = currentUser.username;
    addressCon.text = currentUser.address;
    phoneNumberCon.text = currentUser.phoneNumber.substring(1);
  }

  void updateUserInfo() {
    if (!formKey.currentState!.validate()) {
      return;
    }

    final User newUserInfo = currentUser;
    newUserInfo.firstname = firstnameCon.text.trim();
    newUserInfo.lastname = lastnameCon.text.trim();
    newUserInfo.username = usernameCon.text.trim();
    newUserInfo.address = addressCon.text.trim();
    newUserInfo.phoneNumber = "0" + phoneNumberCon.text.trim();

    setState(() {
      isVisible = true;
    });

    Get.find<UserController>().updateUserInfo(newUserInfo).then((value) {
      setState(() {
        isVisible = false;
      });
      if (value) {
        showToast("success".tr);
        Get.back();
      } else {
        showToast("fail".tr);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text("editProfile".tr),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    TypeTextField(
                      labelText: "firstName".tr,
                      controller: firstnameCon,
                      inputType: TextInputType.name,
                    ),
                    commonHeightSpacing(height: 18),
                    TypeTextField(
                      labelText: "lastName".tr,
                      controller: lastnameCon,
                      inputType: TextInputType.name,
                    ),
                    commonHeightSpacing(height: 18),
                    TypeTextField(
                      labelText: "userName",
                      controller: usernameCon,
                    ),
                    commonHeightSpacing(height: 18),
                    TypeTextField(
                      labelText: "address".tr,
                      controller: addressCon,
                    ),
                    commonHeightSpacing(height: 18),
                    TypeTextField(
                      labelText: "phoneNumber".tr,
                      controller: phoneNumberCon,
                      inputType: TextInputType.phone,
                      prefix: "0",
                      maxLength: 10,
                      validator: (value) {
                        return validatePhoneNumber(value);
                      },
                    ),
                    commonHeightSpacing(height: 18),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: updateUserInfo,
                        child: Text("save".tr.toUpperCase()),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Visibility(
            visible: isVisible,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ],
      ),
    );
  }
}
