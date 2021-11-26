import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mygoods_flutter/components/TypeTextField.dart';
import 'package:mygoods_flutter/controllers/UserController.dart';
import 'package:mygoods_flutter/models/user.dart';
import 'package:mygoods_flutter/services/user_service.dart';
import 'package:mygoods_flutter/utils/constant.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({
    Key? key,
    required this.user,
    // this.user,
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
    firstnameCon.text = currentUser.firstName;
    lastnameCon.text = currentUser.lastName;
    usernameCon.text = currentUser.username;
    addressCon.text = currentUser.address;
    phoneNumberCon.text = currentUser.phoneNumber.substring(1);
  }

  void updateUserInfo() {
    if (!formKey.currentState!.validate()) {
      return;
    }

    final User newUserInfo = currentUser;
    newUserInfo.firstName = firstnameCon.text.trim();
    newUserInfo.lastName = lastnameCon.text.trim();
    newUserInfo.username = usernameCon.text.trim();
    newUserInfo.address = addressCon.text.trim();
    newUserInfo.phoneNumber = "0"+phoneNumberCon.text.trim();

    setState(() {
      isVisible = true;
    });

    Get.find<UserController>().updateUserInfo(newUserInfo).then((value) {
      setState(() {
        isVisible = false;
      });
      if (value) {
        showToast("User Information update successfully");
        Get.back();
      } else {
        showToast("User Information update unsuccessfully");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(10),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    TypeTextField(
                      labelText: "Firstname",
                      controller: firstnameCon,
                      inputType: TextInputType.name,
                    ),
                    Divider(
                      height: 20,
                    ),
                    TypeTextField(
                      labelText: "Lastname",
                      controller: lastnameCon,
                      inputType: TextInputType.name,
                    ),
                    Divider(
                      height: 20,
                    ),
                    TypeTextField(
                      labelText: "Username",
                      controller: usernameCon,
                    ),
                    Divider(
                      height: 20,
                    ),
                    TypeTextField(
                      labelText: "Address",
                      controller: addressCon,
                    ),
                    Divider(
                      height: 20,
                    ),
                    TypeTextField(
                      labelText: "Phone Number",
                      controller: phoneNumberCon,
                      inputType: TextInputType.phone,
                      prefix: "0",
                      maxLength: 10,
                      validator: (value) {
                        return validatePhoneNumber(value);
                      },
                    ),
                    Divider(
                      height: 20,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: updateUserInfo,
                        child: Text("Save".toUpperCase()),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Visibility(
              visible: isVisible,
              child: Center(
                child: CircularProgressIndicator(),
              )),
        ],
      ),
    );
  }
}
