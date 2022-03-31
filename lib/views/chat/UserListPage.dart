import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:get/get.dart';
import 'package:mygoods_flutter/controllers/UserController.dart';
import 'package:mygoods_flutter/services/ChatService.dart';
import 'package:mygoods_flutter/utils/constant.dart';
import 'package:mygoods_flutter/models/user.dart' as myUser;

class UserListPage extends StatefulWidget {
  const UserListPage({Key? key}) : super(key: key);

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

  void checkCurrentUserHaveChatData() async {
    final currentUser = await FirebaseFirestore.instance
        .collection("chatUsers")
        .doc("${fireChatCore.firebaseUser?.uid}")
        .get();
    if (!currentUser.exists) {
      final currentUser = Get.find<UserController>().user!.value;
      await fireChatCore.createUserInFirestore(
        types.User(
          id: currentUser.userId,
          firstName: currentUser.firstname,
          lastName: currentUser.lastname,
          imageUrl: (currentUser.image == null)
              ? dummyNetworkImage
              : currentUser.image!.imageUrl,
        ),
      );
    }
  }

  Widget authenticatedUserRow(myUser.User user) {
    return InkWell(
      onTap: () async {
        setState(() {
          isShow = true;
        });

        final otherUser = types.User(
          id: user.userId,
          firstName: user.firstname,
          lastName: user.lastname,
          imageUrl:
              (user.image == null) ? dummyNetworkImage : user.image!.imageUrl,
        );

        checkCurrentUserHaveChatData();

        await fireChatCore.createUserInFirestore(otherUser);
        await fireChatCore.createRoom(otherUser).then((value) {
          setState(() {
            isShow = true;
          });
          Get.back();
        });
      },
      child: ListTile(
        title: Text(
          "${user.firstname} ${user.lastname}",
        ),
        leading: CircleAvatar(
          backgroundImage: ExtendedNetworkImageProvider(
            (user.image == null) ? dummyNetworkImage : user.image!.imageUrl,
          ),
          radius: 30,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Click on user to start chat"),
      ),
      body: Stack(
        children: [
          Center(
            child: Visibility(
              maintainSize: false,
              visible: isShow,
              child: const CircularProgressIndicator(),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: FutureBuilder<List<myUser.User>>(
              future: chatService.getAllAuthenticatedUsers(),
              initialData: const [],
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final listOfUsers = snapshot.data!;
                  return ListView.separated(
                    itemCount: listOfUsers.length,
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        height: 8,
                      );
                    },
                    itemBuilder: (context, index) {
                      final user = listOfUsers[index];
                      return authenticatedUserRow(user);
                    },
                  );
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text("Error"),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
