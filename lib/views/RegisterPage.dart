import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:get/get.dart';
import 'package:mygoods_flutter/components/TypeTextField.dart';
import 'package:mygoods_flutter/controllers/UserController.dart';
import 'package:mygoods_flutter/models/user.dart';
import 'package:mygoods_flutter/services/UserService.dart';
import 'package:mygoods_flutter/models/image.dart' as myImage;
import 'package:mygoods_flutter/views/MainActivity.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class RegisterPage extends StatefulWidget {
  const RegisterPage({
    Key? key,
    required this.userId,
    this.phoneNumber,
  }) : super(key: key);

  final String userId;
  final String? phoneNumber;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final firstnameCon = TextEditingController(),
      lastnameCon = TextEditingController(),
      usernameCon = TextEditingController(),
      phoneCon = TextEditingController(),
      addressCon = TextEditingController();

  final GlobalKey formKey = GlobalKey<FormState>();
  late String? phoneNumber = widget.phoneNumber;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Register Data"),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              top: 5,
            ),
            child: Column(
              children: [
                topTextViews(),
                const SizedBox(
                  height: 20,
                ),
                registerForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  topTextViews() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          "Create an Account",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          "Welcome, please create an account for using our app more easily. Just a few minute! ",
          style: TextStyle(fontSize: 14),
        )
      ],
    );
  }

  registerForm() {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TypeTextField(
            labelText: "Firstname",
            inputType: TextInputType.name,
            controller: firstnameCon,
          ),
          const SizedBox(
            height: 20,
          ),
          TypeTextField(
            labelText: "Lastname",
            inputType: TextInputType.name,
            controller: lastnameCon,
          ),
          const SizedBox(
            height: 20,
          ),
          TypeTextField(
            labelText: "Username",
            inputType: TextInputType.name,
            controller: usernameCon,
          ),
          (phoneNumber == null)
              ? Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    TypeTextField(
                      labelText: "Phone Number",
                      controller: phoneCon,
                      inputType: TextInputType.phone,
                      prefix: "0",
                      maxLength: 9,
                      buildCounter: (
                        context, {
                        required currentLength,
                        required isFocused,
                        maxLength,
                      }) {
                        return Text(
                          '${currentLength + 1}/${maxLength! + 1}',
                          semanticsLabel: 'character count',
                          style: const TextStyle(fontSize: 12, height: 1),
                        );
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Field Empty";
                        }
                        if (!GetUtils.isPhoneNumber("0$value")) {
                          return "Wrong Phone Format";
                        }
                        return null;
                      },
                    ),
                  ],
                )
              : Container(),
          const SizedBox(
            height: 20,
          ),
          TypeTextField(
            labelText: "Address",
            controller: addressCon,
            inputType: TextInputType.streetAddress,
            hint: "Address (City or Province Name)",
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 40,
            width: double.maxFinite,
            child: ElevatedButton(
              onPressed: () {
                putDataIntoFirestore();
              },
              child: Text("Complete Sign Up".toUpperCase()),
            ),
          )
        ],
      ),
    );
  }

  final userService = UserService();

  Future<void> putDataIntoFirestore() async {
    final username = usernameCon.text.trim();
    final firstname = firstnameCon.text.trim();
    final lastname = lastnameCon.text.trim();
    final address = addressCon.text.trim();
    phoneNumber ??= phoneCon.text.trim();
    final User user = User(
      userId: widget.userId,
      username: username,
      firstName: firstname,
      lastName: lastname,
      email: "",
      phoneNumber: phoneNumber!,
      address: address,
      image: myImage.Image(imageName: "", imageUrl: ""),
      preferenceId: [],
    );

    await FirebaseChatCore.instance.createUserInFirestore(
      types.User(
        id: user.userId,
        firstName: user.firstName,
        imageUrl: user.image?.imageUrl,
        lastName: user.lastName,
      ),
    );

    await userService.registerUser(user).then((value) {
      Get.delete<UserController>();
      Get.lazyPut(() => UserController(), fenix: true);
      Get.offAll(() => const MainActivity());
    });
  }
}
