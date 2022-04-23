import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:get/get.dart';
import 'package:mygoods_flutter/utils/constant.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:mygoods_flutter/views/chat/ChatRow.dart';
import 'UserListPage.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({
    Key? key,
  }) : super(key: key);

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  final fireChatCore = FirebaseChatCore.instance;

  void showFilterDialog() {
    final textStyle = TextStyle(fontFamily: getFont());

    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
              child: Text(
                "all".tr,
                style: textStyle,
              ),
              onPressed: () {},
            ),
            CupertinoActionSheetAction(
              child: Text(
                "buy".tr,
                style: textStyle,
              ),
              onPressed: () {},
            ),
            CupertinoActionSheetAction(
              child: Text(
                "sell".tr,
                style: textStyle,
              ),
              onPressed: () {},
            ),
            CupertinoActionSheetAction(
              child: Text(
                "unread".tr,
                style: textStyle,
              ),
              onPressed: () {},
            ),
            CupertinoActionSheetAction(
              child: Text(
                "blockUser".tr,
                style: textStyle,
              ),
              onPressed: () {},
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: Text(
              "cancel".tr,
              style: textStyle,
            ),
            onPressed: () {
              Get.back(closeOverlays: true);
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("message".tr),
        actions: [
          IconButton(
            onPressed: () {
              requestFocus(context);
              showFilterDialog();
            },
            icon: const Icon(Icons.filter_list),
          ),
          IconButton(
            onPressed: () {
              Get.to(() => const UserListPage());
            },
            icon: const Icon(Icons.person_add),
          ),
        ],
      ),
      body: StreamBuilder<List<types.Room>>(
        stream: FirebaseChatCore.instance.rooms(),
        initialData: const [],
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Container(
              alignment: Alignment.center,
              child: const Text('No rooms'),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final room = snapshot.data![index];
              return ChatRoomRow(room: room);
            },
          );
        },
      ),
    );
  }
}
