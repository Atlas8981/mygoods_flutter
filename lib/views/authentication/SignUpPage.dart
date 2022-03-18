import 'dart:math';

import 'package:cupertino_stepper/cupertino_stepper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mygoods_flutter/components/TypeTextField.dart';
import 'package:mygoods_flutter/models/user/userDto.dart';
import 'package:mygoods_flutter/services/RegisterService.dart';
import 'package:mygoods_flutter/utils/constant.dart';
import 'package:mygoods_flutter/views/authentication/VerifyEmailPage.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final registerService = RegisterService();

  final emailCon = TextEditingController();
  final firstNameCon = TextEditingController();
  final lastNameCon = TextEditingController();
  final phoneCon = TextEditingController();
  final passwordCon = TextEditingController();
  final addressCon = TextEditingController();

  bool obscureText = true;

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Please Enter Information Below",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Welcome to MyGoods, please enter the following information",
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(
                  height: 20,
                ),
                OrientationBuilder(
                  builder: (context, orientation) {
                    switch (orientation) {
                      case Orientation.portrait:
                        return _buildStepper(StepperType.vertical);
                      case Orientation.landscape:
                        return _buildStepper(StepperType.horizontal);
                        break;
                    }
                  },
                ),
                // Form(
                //   key: formKey,
                //   child: AutofillGroup(
                //     child: Column(
                //       children: [
                //         TypeTextField(
                //           labelText: "Email",
                //           controller: emailCon,
                //           prefixIcon: Icon(Icons.email_outlined),
                //           autoFillHints: const [
                //             AutofillHints.email,
                //           ],
                //         ),
                //         SizedBox(
                //           height: 20,
                //         ),
                //         TypeTextField(
                //           labelText: "Password",
                //           controller: passwordCon,
                //           prefixIcon: Icon(Icons.password),
                //           inputType: TextInputType.visiblePassword,
                //           obscureText: obscureText,
                //           suffixIcon: IconButton(
                //             onPressed: () {
                //               setState(() {
                //                 obscureText = !obscureText;
                //               });
                //             },
                //             icon: obscureText
                //                 ? Icon(Icons.visibility)
                //                 : Icon(Icons.visibility_off),
                //           ),
                //           autoFillHints: const [AutofillHints.newPassword],
                //         ),
                //         SizedBox(
                //           height: 20,
                //         ),
                //         TypeTextField(
                //           labelText: "Firstname",
                //           controller: firstNameCon,
                //           prefixIcon: Icon(Icons.person),
                //           autoFillHints: const [AutofillHints.familyName],
                //         ),
                //         SizedBox(
                //           height: 20,
                //         ),
                //         TypeTextField(
                //           labelText: "Lastname",
                //           controller: lastNameCon,
                //           prefixIcon: Icon(Icons.person),
                //           autoFillHints: const [AutofillHints.givenName],
                //         ),
                //         SizedBox(
                //           height: 20,
                //         ),
                //         TypeTextField(
                //           labelText: "Phone Numbers",
                //           controller: phoneCon,
                //           inputType: TextInputType.phone,
                //           prefixIcon: Icon(Icons.phone),
                //           autoFillHints: const [
                //             AutofillHints.telephoneNumberDevice,
                //             AutofillHints.telephoneNumber,
                //           ],
                //         ),
                //         SizedBox(
                //           height: 20,
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: signUpButtonClick,
                        child: Text(
                          "Sign In".toUpperCase(),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  int currentStep = 0;

  CupertinoStepper _buildStepper(StepperType type) {
    final List<TypeTextField> textFields = [
      TypeTextField(
        labelText: "Email",
        controller: emailCon,
        prefixIcon: Icon(Icons.email_outlined),
        autoFillHints: const [
          AutofillHints.email,
        ],
      ),
      TypeTextField(
        labelText: "Password",
        controller: passwordCon,
        prefixIcon: Icon(Icons.password),
        inputType: TextInputType.visiblePassword,
        obscureText: obscureText,
        suffixIcon: IconButton(
          onPressed: () {
            print("asdas");
            setState(() {
              obscureText = !obscureText;
              print(obscureText);
            });
          },
          icon:
              obscureText ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
        ),
        autoFillHints: const [AutofillHints.newPassword],
      ),
      TypeTextField(
        labelText: "Firstname",
        controller: firstNameCon,
        prefixIcon: Icon(Icons.person),
        autoFillHints: const [AutofillHints.familyName],
      ),
      TypeTextField(
        labelText: "Lastname",
        controller: lastNameCon,
        prefixIcon: Icon(Icons.person),
        autoFillHints: const [AutofillHints.givenName],
      ),
      TypeTextField(
        labelText: "Phone Numbers",
        controller: phoneCon,
        inputType: TextInputType.phone,
        prefixIcon: Icon(Icons.phone),
        autoFillHints: const [
          AutofillHints.telephoneNumberDevice,
          AutofillHints.telephoneNumber,
        ],
      ),
      TypeTextField(
        labelText: "Address",
        controller: addressCon,
        inputType: TextInputType.streetAddress,
        prefixIcon: Icon(Icons.home),
        autoFillHints: const [
          AutofillHints.fullStreetAddress,
          AutofillHints.addressCity,
        ],
      ),
    ];
    final canCancel = currentStep > 0;
    final canContinue = currentStep < textFields.length - 1;
    return CupertinoStepper(
      type: type,
      currentStep: currentStep,
      physics: NeverScrollableScrollPhysics(),
      onStepTapped: (step) {
        return setState(() {
          currentStep = step;
        });
      },
      onStepCancel: canCancel ? () => setState(() => --currentStep) : null,
      onStepContinue: () {
        if (currentStep == textFields.length - 1) {
          registerUser();
        } else {
          setState(() {
            ++currentStep;
          });
        }
      },
      steps: [
        for (var i = 0; i < textFields.length; ++i)
          Step(
            title: Text(textFields[i].labelText),
            isActive: i == currentStep,
            state: i == currentStep
                ? StepState.editing
                : i < currentStep
                    ? StepState.complete
                    : StepState.indexed,
            content: textFields[i],
          ),
      ],
    );
  }

  Step _buildStep({
    required Widget title,
    StepState state = StepState.indexed,
    bool isActive = false,
  }) {
    return Step(
      title: title,
      subtitle: Text('Subtitle'),
      state: state,
      isActive: isActive,
      content: LimitedBox(
        maxWidth: 300,
        maxHeight: 300,
        child: Container(color: CupertinoColors.systemGrey),
      ),
    );
  }

  void signUpButtonClick() {
    Get.to(
      () => VerifyEmailPage(
        email: "",
        username: "",
      ),
    );
    // registerUser();
  }

  Future<void> registerUser() async {
    print("Registering user...");
    final rng = Random();
    final int code = rng.nextInt(900000) + 100;
    final password = passwordCon.text;
    final firstname = firstNameCon.text;
    final lastname = lastNameCon.text;
    final username = firstname + lastname + code.toString();
    final primaryPhone = phoneCon.text;
    final List<String> phones = [];
    phones.add(primaryPhone);
    final email = emailCon.text;
    final address = addressCon.text;

    final userDto = UserDto(
      password: password,
      firstname: firstname,
      lastname: lastname,
      username: username,
      primaryPhone: primaryPhone,
      phones: phones,
      email: email,
      address: address,
    );
    final isDone = await registerService.register(userDto);
    if (isDone) {
      showToast("Register Success");
      Get.to(
        () => VerifyEmailPage(
          username: username,
          email: email,
        ),
      );
    } else {
      showToast("Something went wrong");
    }
  }
}
