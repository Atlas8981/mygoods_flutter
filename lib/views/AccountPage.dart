import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mygoods_flutter/components/CustomAlertDialog.dart';
import 'package:mygoods_flutter/controllers/BottomNavigationViewController.dart';
import 'package:mygoods_flutter/controllers/UserController.dart';
import 'package:mygoods_flutter/models/category.dart';
import 'package:mygoods_flutter/models/user.dart' as myUser;
import 'package:mygoods_flutter/services/user_service.dart';
import 'package:mygoods_flutter/utils/constant.dart';
import 'package:mygoods_flutter/views/EditProfilePage.dart';
import 'package:mygoods_flutter/views/authentication/ResetPasswordPage.dart';
import 'package:mygoods_flutter/views/cells/category_item_row.dart';
import 'package:mygoods_flutter/views/MyItemPage.dart';
import 'package:mygoods_flutter/views/other/big_image.dart';

class AboutMePage extends StatelessWidget {
  final userService = UserService();

  late final List<Category> bottomListItems = [
    Category(name: "My Item", image: "${imageDir}myitem.png"),
    Category(name: "Saved", image: "${imageDir}saved.png"),
    Category(name: "About Our App", image: "${imageDir}aboutus.png"),
    Category(name: "Terms & Conditions", image: "${imageDir}term.png"),
  ];
  late myUser.User user;

  @override
  Widget build(BuildContext context) {
    double height =
        Get.height - AppBar().preferredSize.height - Get.bottomBarHeight;
    // MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("About Me"),
        actions: [
          PopupMenuButton<AccountMenuItems>(
            icon: Icon(Icons.more_vert),
            onSelected: (AccountMenuItems value) {
              switch (value) {
                case AccountMenuItems.editProfile:
                  Get.to(EditProfilePage(
                    user: user,
                  ));
                  break;
                case AccountMenuItems.resetPassword:
                  Get.to(ResetPasswordPage());
                  break;
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<AccountMenuItems>(
                value: AccountMenuItems.editProfile,
                child: Text("Edit Profile"),
                // child: Text('setting'.tr),
              ),
              PopupMenuItem<AccountMenuItems>(
                value: AccountMenuItems.resetPassword,
                child: Text('Reset Password'),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
              top: 20,
            ),
            // color: Colors.blue,
            // height: height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.max,
              children: [
                centerProfile(),
                Divider(
                  height: 70,
                  thickness: 10,
                  color: Colors.grey.withOpacity(0.3),
                ),
                bottomListWidgets(),
                Divider(
                  height: 100,
                ),
                Container(
                  width: double.infinity,
                  height: 50,
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: ElevatedButton(
                    onPressed: () {
                      onSignOutButtonClick(context);
                    },
                    child: Text(
                      "Sign Out".toUpperCase(),
                      style: TextStyle(letterSpacing: 1.1),
                    ),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(redColor)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  centerProfile() {
    return Center(
      child: GetBuilder<UserController>(
        builder: (controller) {
          if (controller.user == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          user = controller.user!.value;
          return Column(
            children: [
              InkWell(
                onLongPress: () async {
                  final XFile? pickedImage = await pickImage();
                  if (pickedImage == null) {
                    return;
                  }
                  controller.changeProfilePicture(pickedImage);
                },
                onTap: () {
                  Get.to(() => BigImagePage(image: user.image));
                },
                child: Hero(
                  tag: user.image.imageName,
                  child: CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(
                      "${user.image.imageUrl}",
                    ),
                    foregroundColor: Colors.white,
                    radius: 65,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "${user.firstName} ${user.lastName}",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text("${user.address}"),
              SizedBox(
                height: 10,
              ),
              Text("${user.phoneNumber}"),
            ],
          );
        },
      ),
    );
  }

  bottomListWidgets() {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: bottomListItems.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              switch (index) {
                case 0:
                  Get.to(() => MyItemsPage());
                  break;
                // case 1:
                //   Get.to(()=>MyItemsPage());
                //   break;
                // case 2:
                //   Get.to(()=>MyItemsPage());
                //   break;
                // case 3:
                //   Get.to(()=>MyItemsPage());
                //   break;
              }
            },
            child: CategoryItemRow(
              assetImage: bottomListItems[index].image,
              name: bottomListItems[index].name,
            ),
          );
        },
      ),
    );
  }

  final ImagePicker imagePicker = ImagePicker();

  Future<XFile?> pickImage() async {
    final XFile? picture =
        await imagePicker.pickImage(source: ImageSource.gallery);
    return picture;
  }

  void onSignOutButtonClick(context) {
    showCustomDialog(
      context,
      title: "Are your sure you want to sign out ?",
      onConfirm: () {
        userService.signOut().then((value) {
          if (value) {
            showToast("Sign Out Successfully");
            Get.find<LandingPageController>().changeTabIndex(0);
          } else {
            showToast("Sign Out Unsuccessfully");
          }
        });
      },
    );
  }
}

enum AccountMenuItems {
  editProfile,
  resetPassword,
}
