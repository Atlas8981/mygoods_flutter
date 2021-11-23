import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mygoods_flutter/services/user_service.dart';
import 'package:mygoods_flutter/views/EditProfilePage.dart';
import 'package:mygoods_flutter/views/authentication/ResetPasswordPage.dart';

class AccountPage extends StatelessWidget {

  final userDatabaseService = UserService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About Me"),
        actions: [
          PopupMenuButton<PopMenuItems>(
            icon: Icon(Icons.more_vert),
            onSelected: (PopMenuItems value) {
              switch (value) {
                case PopMenuItems.editProfile:
                  Get.to(EditProfilePage());
                  break;
                case PopMenuItems.resetPassword:
                  Get.to(ResetPasswordPage());
                  break;
              }
            },
            itemBuilder: (BuildContext context) =>
            [
              PopupMenuItem<PopMenuItems>(
                value: PopMenuItems.editProfile,
                child: Text("Edit Profile"),
                // child: Text('setting'.tr),
              ),
              PopupMenuItem<PopMenuItems>(
                value: PopMenuItems.resetPassword,
                child: Text('Reset Password'),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                centerProfile()
              ],
            ),
          ),
        ),
      ),
    );
  }


  centerProfile() {
    return Center(
      child: Column(
        children: [
          // CircleAvatar(
          //   backgroundImage:,
          // )
        ],
      ),
    );
  }
}

enum PopMenuItems {
  editProfile,
  resetPassword,
}
