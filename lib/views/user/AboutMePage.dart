import 'dart:io';

import 'package:avatars/avatars.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mygoods_flutter/components/CustomAlertDialog.dart';
import 'package:mygoods_flutter/controllers/BottomNavigationViewController.dart';
import 'package:mygoods_flutter/controllers/HomePageController.dart';
import 'package:mygoods_flutter/controllers/ItemFormController.dart';
import 'package:mygoods_flutter/controllers/UserController.dart';
import 'package:mygoods_flutter/models/category.dart';
import 'package:mygoods_flutter/models/user.dart' as myUser;
import 'package:mygoods_flutter/models/user.dart';
import 'package:mygoods_flutter/services/AuthenticationService.dart';
import 'package:mygoods_flutter/utils/constant.dart';
import 'package:mygoods_flutter/views/utils/AboutOurAppPage.dart';
import 'package:mygoods_flutter/views/utils/CropImagePage.dart';
import 'package:mygoods_flutter/views/user/EditProfilePage.dart';
import 'package:mygoods_flutter/views/utils/ImagePreviewerPage.dart';
import 'package:mygoods_flutter/views/user/SavedItemsPage.dart';
import 'package:mygoods_flutter/views/authentication/ResetPasswordPage.dart';
import 'package:mygoods_flutter/views/cells/MenuItemRow.dart';
import 'package:mygoods_flutter/views/item/MyItemPage.dart';
import 'package:mygoods_flutter/views/utils/ImageViewerPage.dart';
import 'package:mygoods_flutter/views/utils/SettingPage.dart';
import 'package:mygoods_flutter/views/utils/TermAndConditionPage.dart';

class AboutMePage extends StatefulWidget {
  const AboutMePage({
    Key? key,
  }) : super(key: key);

  @override
  State<AboutMePage> createState() => _AboutMePageState();
}

class _AboutMePageState extends State<AboutMePage> {
  final authService = AuthenticationService();

  late final List<Category> bottomListItems = [
    Category(name: "My Item", image: "${imageDir}myitem.png"),
    Category(name: "Saved", image: "${imageDir}saved.png"),
    Category(name: "About Our App", image: "${imageDir}aboutus.png"),
    Category(name: "Terms & Conditions", image: "${imageDir}term.png"),
  ];

  late myUser.User user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("About Me"),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(() => const SettingPage());
            },
            icon: const Icon(Icons.settings),
          ),
          popUpMenu(),
        ],
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(top: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Column(
                children: [
                  centerProfile(),
                  Divider(
                    height: 70,
                    thickness: 10,
                    color: Colors.grey.withOpacity(0.3),
                  ),
                  bottomListWidgets(),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Container(
                  width: double.infinity,
                  height: 50,
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      onSignOutButtonClick(context);
                    },
                    child: Text(
                      "Sign Out".toUpperCase(),
                      style: const TextStyle(letterSpacing: 1.1),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(redColor),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget popUpMenu() {
    return PopupMenuButton<AccountMenuItems>(
      icon: const Icon(Icons.more_vert),
      onSelected: (AccountMenuItems value) {
        switch (value) {
          case AccountMenuItems.editProfile:
            Get.to(() => EditProfilePage(
                  user: user,
                ));
            break;
          case AccountMenuItems.resetPassword:
            Get.to(() => const ResetPasswordPage());
            break;
        }
      },
      itemBuilder: (BuildContext context) => [
        const PopupMenuItem<AccountMenuItems>(
          value: AccountMenuItems.editProfile,
          child: Text("Edit Profile"),
        ),
        const PopupMenuItem<AccountMenuItems>(
          value: AccountMenuItems.resetPassword,
          child: Text('Reset Password'),
        ),
      ],
    );
  }

  Widget userImage(UserController controller, User user) {
    if (user.image != null && user.image!.imageUrl.isNotEmpty) {
      final tag = "${user.image!.imageName} ${DateTime.now()}";
      return InkWell(
        onLongPress: () async {
          changeProfile(controller);
        },
        onTap: () {
          Get.to(
            () => ImageViewerPage(
              image: user.image!.imageUrl,
              tag: tag,
            ),
          );
        },
        child: Hero(
          tag: tag,
          child: CircleAvatar(
            backgroundColor: Colors.white,
            radius: 65,
            backgroundImage: ExtendedNetworkImageProvider(
              user.image!.imageUrl,
              cache: true,
              cacheRawData: true,
            ),
          ),
        ),
      );
    } else {
      final String fullName = "${user.firstname} ${user.lastname}";
      return Stack(
        alignment: Alignment.center,
        children: [
          InkWell(
            onLongPress: () async {
              changeProfile(controller);
            },
            child: Avatar(
              name: fullName,
              onTap: () {},
              value: fullName,
            ),
          ),
          Visibility(
            visible: user.image!.imageName == "pending",
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ],
      );
    }
  }

  Future<void> changeProfile(UserController controller) async {
    final XFile? pickedImage = await pickImage();
    if (pickedImage == null) {
      return;
    }

    final File? cropImage = await Get.to(
      () => CropImagePage(
        userImage: pickedImage,
      ),
    );
    if (cropImage != null) {
      final bool acceptable = await Get.to(
        () => ImagePreviewerPage(image: cropImage),
        fullscreenDialog: true,
      );
      if (acceptable) {
        controller.changeProfilePicture(XFile(cropImage.path));
      }
    }
  }

  Widget centerProfile() {
    return GetBuilder<UserController>(
      builder: (controller) {
        if (controller.user == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        user = controller.user!.value;
        return Stack(
          children: [
            // Positioned.fill(
            //   bottom: 100,
            //   child: Image.network(
            //     networkBackgroundImage,
            //     fit: BoxFit.cover,
            //
            //   ),
            // ),
            SizedBox(
              width: double.maxFinite,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  userImage(controller, user),
                  const SizedBox(height: 10),
                  Text(
                    "${user.firstname} ${user.lastname}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(user.address),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(user.phoneNumber),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget bottomListWidgets() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: ListView.separated(
        separatorBuilder: (context, index) {
          return Divider(
            height: 0,
            thickness: 2,
          );
        },
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: bottomListItems.length,
        itemBuilder: (context, index) {
          return MenuItemRow(
            onTap: () {
              switch (index) {
                case 0:
                  Get.to(() => MyItemsPage());
                  break;
                case 1:
                  Get.to(() => SavedItemsPage());
                  break;
                case 2:
                  Get.to(() => const AboutOurAppPage());
                  break;
                case 3:
                  Get.to(() => const TermAndConditionPage());
                  break;
              }
            },
            assetImage: bottomListItems[index].image,
            name: bottomListItems[index].name,
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
        authService.signOut().then((value) async {
          if (value) {
            await Get.delete<UserController>();
            await Get.delete<ItemFormController>();
            final homePageController = Get.find<HomePageController>();
            homePageController.clearRecentViewItem();

            Get.back();
            Get.find<LandingPageController>().changeTabIndex(0);
            showToast("Sign Out Successfully");
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
