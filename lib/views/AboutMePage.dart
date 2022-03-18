import 'package:avatars/avatars.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mygoods_flutter/components/CustomAlertDialog.dart';
import 'package:mygoods_flutter/controllers/BottomNavigationViewController.dart';
import 'package:mygoods_flutter/controllers/UserController.dart';
import 'package:mygoods_flutter/models/item/category.dart';
import 'package:mygoods_flutter/models/image.dart' as myImage;
import 'package:mygoods_flutter/models/user/user.dart' as myUser;
import 'package:mygoods_flutter/models/user/user.dart';
import 'package:mygoods_flutter/services/UserService.dart';
import 'package:mygoods_flutter/utils/constant.dart';
import 'package:mygoods_flutter/views/EditProfilePage.dart';
import 'package:mygoods_flutter/views/SavedItemsPage.dart';
import 'package:mygoods_flutter/views/authentication/ResetPasswordPage.dart';
import 'package:mygoods_flutter/views/cells/category_item_row.dart';
import 'package:mygoods_flutter/views/MyItemPage.dart';
import 'package:mygoods_flutter/views/other/big_image.dart';

class AboutMePage extends StatefulWidget {
  const AboutMePage({Key? key}) : super(key: key);

  @override
  State<AboutMePage> createState() => _AboutMePageState();
}

class _AboutMePageState extends State<AboutMePage> {
  final userService = UserService();

  late final List<MenuItem> bottomListItems = [
    MenuItem(name: "My Item", image: "${imageDir}myitem.png"),
    MenuItem(name: "Saved", image: "${imageDir}saved.png"),
    MenuItem(name: "About Our App", image: "${imageDir}aboutus.png"),
    MenuItem(name: "Terms & Conditions", image: "${imageDir}term.png"),
  ];

  late myUser.User user;

  @override
  Widget build(BuildContext context) {
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

  Widget checkUserImage(UserController controller, User user) {
    if (user.image != null && user.image!.imageUrl.isNotEmpty) {
      return InkWell(
        onLongPress: () async {
          final XFile? pickedImage = await pickImage();
          if (pickedImage == null) {
            return;
          }
          controller.changeProfilePicture(pickedImage);
        },
        onTap: () {
          Get.to(() => BigImagePage(image: user.image!));
        },
        child: Hero(
          tag: user.image!.imageName,
          child: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(
              user.image!.imageUrl,
            ),
            child: Visibility(
              visible: user.image!.imageUrl.isEmpty,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
            backgroundColor: Colors.white,
            radius: 65,
          ),
        ),
      );
    } else {
      String fullName = "${user.firstName} ${user.lastName}";
      return Stack(
        alignment: Alignment.center,
        children: [
          InkWell(
            onLongPress: () async {
              final XFile? pickedImage = await pickImage();
              if (pickedImage == null) {
                return;
              }
              controller.changeProfilePicture(pickedImage);
            },
            child:
                // SvgPicture.network(
                //   "https://avatars.dicebear.com/api/identicon/name.svg",
                //   height: 120,
                //   fit: BoxFit.cover,
                //   key: UniqueKey(),
                // ),
                Avatar(
              name: fullName,
              onTap: () {},
              value: fullName,
            ),
          ),
          Visibility(
              visible: user.image!.imageName == "pending",
              child: Center(
                child: CircularProgressIndicator(),
              )),
        ],
      );
    }
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
              checkUserImage(controller, user),
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
              Text(user.address),
              SizedBox(
                height: 10,
              ),
              Text(user.phoneNumber),
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
                  // Get.to(() => MyItemsPage());
                  break;
                case 1:
                  // Get.to(() => SavedItemsPage());
                  break;
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
            Get.back();
            Get.find<LandingPageController>().changeTabIndex(0);
          } else {
            showToast("Sign Out Unsuccessfully");
          }
        });
      },
    );
  }
}

class MenuItem {
  const MenuItem({
    required this.name,
    required this.image,
  });

  final String name;
  final String image;
}

enum AccountMenuItems {
  editProfile,
  resetPassword,
}
