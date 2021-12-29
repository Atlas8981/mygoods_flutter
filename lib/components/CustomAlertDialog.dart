import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> showCustomDialog(
  context, {
  String? title,
  Function()? onCancel,
  Function()? onConfirm,
}) async {
  return showDialog<void>(
    context: context,
    useSafeArea: true,
    barrierDismissible: true, // user must tap button!
    builder: (_) => Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          margin: EdgeInsets.only(top: 20, left: 20, right: 20),
          // color: Colors.transparent,
          decoration: BoxDecoration(
              // border: Border.all(
              //   color: Colors.red,
              // ),
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(5))),
          width: double.infinity,
          height: 120,
          // color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(top: 20, left: 20),
                  // color: Colors.red,
                  child: Text(
                    // "Are you sure you want to sign out ?",
                    title ?? "Do you want to that ?",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: onCancel ?? () => Get.back(),
                      // onPressed: () {
                      //   Get.back();
                      // },
                      child: Text("No")),
                  TextButton(
                      onPressed: onConfirm ?? () => Get.back(),
                      // onPressed: () {
                      //   Get.offAll(() => SplashPage());
                      // },
                      child: Text("Yes")),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

void showSingleChoiceAlertDialog(
  BuildContext context, {
  Function()? onClickOk,
}) {
  final String title = "noInternetTitle".tr;
  final String content = "noInternetSubtitle".tr;
  Widget okButton = TextButton(
    child: Text("okButtonText".tr),
    onPressed: onClickOk ??
        () {
          Get.back();
        },
  );
  AlertDialog alert = AlertDialog(
    title: Text(title),
    content: Text(content),
    actions: [
      okButton,
    ],
  );

  CupertinoAlertDialog cupertinoAlert = CupertinoAlertDialog(
    title: Text(title),
    content: Text(content),
    actions: [
      okButton,
    ],
  );

  if (GetPlatform.isAndroid) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  } else if (GetPlatform.isIOS) {
    showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return cupertinoAlert;
      },
    );
  }
  // show the dialog
}
