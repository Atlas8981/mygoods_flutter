import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:get/get.dart';
import 'package:mygoods_flutter/controllers/UserController.dart';
import 'package:mygoods_flutter/services/ChatService.dart';
import 'package:mygoods_flutter/utils/constant.dart';
import 'package:mygoods_flutter/models/user.dart' as myUser;

class UserListPage extends StatefulWidget {
  UserListPage({Key? key}) : super(key: key);

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  final chatService = ChatService();
  bool isShow = false;
  final fireChatCore = FirebaseChatCore.instance;

  void deleteUsers(String userId) {
    fireChatCore.deleteUserFromFirestore(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Visibility(
                maintainSize: false,
                visible: isShow,
                child: CircularProgressIndicator()),
          ),
          FutureBuilder<List<myUser.User>>(
            future: chatService.getAllAuthenticatedUsers(),
            initialData: const [],
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final listOfUsers = snapshot.data!;
                return ListView.separated(
                    itemCount: listOfUsers.length,
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        height: 8,
                      );
                    },
                    itemBuilder: (context, index) {
                      final user = listOfUsers[index];
                      return InkWell(
                        onTap: () async {
                          setState(() {
                            isShow = true;
                          });

                          final otherUser = types.User(
                            id: user.userId,
                            firstName: user.firstName,
                            lastName: user.lastName,
                            imageUrl: (user.image == null)
                                ? dummyNetworkImage
                                : user.image!.imageUrl,
                          );
                          // final currentUser = Get.find<UserController>().user!.value;
                          // final otherUser = types.User(
                          //   id: FirebaseAuth.instance.currentUser!.uid,
                          //   firstName: currentUser.firstName,
                          //   lastName: currentUser.lastName,
                          //   imageUrl: (currentUser.image == null)
                          //       ? dummyNetworkImage
                          //       : currentUser.image!.imageUrl,
                          // );

                          await fireChatCore
                              .createUserInFirestore(otherUser)
                              .then((value) {
                            print("User Created");
                          });

                          await FirebaseChatCore.instance
                              .createRoom(otherUser)
                              .then((value) {
                            setState(() {
                              isShow = true;
                            });
                            Get.back();
                          });
                        },
                        child: Container(
                          child: ListTile(
                            title: Text(
                              "${user.firstName} ${user.lastName}",
                            ),
                            leading: CircleAvatar(
                              backgroundImage: CachedNetworkImageProvider(
                                (user.image == null)
                                    ? dummyNetworkImage
                                    : user.image!.imageUrl,
                              ),
                              radius: 30,
                            ),
                          ),
                        ),
                      );
                    });
              } else if (snapshot.hasError) {
                return Center(
                  child: Text("Error"),
                );
              }

              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ],
      ),
    );
  }
}
