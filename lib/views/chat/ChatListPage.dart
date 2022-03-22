import 'package:avatars/avatars.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mygoods_flutter/utils/constant.dart';
import 'package:mygoods_flutter/views/chat/ChatRoom.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'UserListPage.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({Key? key}) : super(key: key);

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  final fireChatCore = FirebaseChatCore.instance;

  void showFilterDialog() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
              child: const Text("All"),
              onPressed: () {},
            ),
            CupertinoActionSheetAction(
              child: const Text("Buy"),
              onPressed: () {},
            ),
            CupertinoActionSheetAction(
              child: const Text("Sell"),
              onPressed: () {},
            ),
            CupertinoActionSheetAction(
              child: const Text("Unread"),
              onPressed: () {},
            ),
            CupertinoActionSheetAction(
              child: const Text("Block User"),
              onPressed: () {},
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: const Text("Cancel"),
            onPressed: () {
              Get.back();
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
        title: const Text("Chat List"),
        actions: [
          IconButton(
            onPressed: () {
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
              margin: const EdgeInsets.only(
                bottom: 200,
              ),
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

class ChatRoomRow extends StatefulWidget {
  const ChatRoomRow({
    Key? key,
    required this.room,
  }) : super(key: key);
  final types.Room room;

  @override
  State<ChatRoomRow> createState() => _ChatRoomRowState();
}

class _ChatRoomRowState extends State<ChatRoomRow> {
  final auth = FirebaseAuth.instance;

  late final types.User _user = types.User(id: auth.currentUser!.uid);

  Future<String> getLastMessage(types.Room room) async {
    if (room.lastMessages == null) {
      return "";
    }
    if (room.lastMessages![0].type == types.MessageType.text) {
      final lastMessageText =
          types.TextMessage.fromJson(room.lastMessages![0].toJson());
      return lastMessageText.text;
    }
    return "";
  }

  Widget _buildAvatar(types.Room room) {
    var color = Colors.transparent;

    if (room.type == types.RoomType.direct) {
      try {
        final otherUser = room.users.firstWhere(
          (u) => u.id != _user.id,
        );

        color = getUserAvatarNameColor(otherUser);
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
        // Do nothing if other user is not found
      }
    }

    final hasImage = room.imageUrl != null && room.imageUrl!.isNotEmpty;
    final name = room.name ?? '';

    return Container(
      margin: const EdgeInsets.only(right: 16),
      key: UniqueKey(),
      child: CircleAvatar(
        backgroundColor: hasImage ? Colors.transparent : color,
        backgroundImage: hasImage
            ? CachedNetworkImageProvider(room.imageUrl ?? dummyNetworkImage)
            : null,
        radius: 30,
        child: !hasImage
            ? Avatar(
                name: name,
                value: name,
                margin: EdgeInsets.zero,
                shape: AvatarShape(
                  width: 60,
                  height: 60,
                  shapeBorder: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                ),
              )
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(
          () => ChatRoom(
            room: widget.room,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        child: Row(
          children: [
            _buildAvatar(widget.room),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.room.name ?? '',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  FutureBuilder<String>(
                    future: getLastMessage(widget.room),
                    builder: (context, snapshot) {
                      final textStyle = TextStyle(
                          color: Colors.black.withOpacity(0.8), fontSize: 12);
                      if (snapshot.hasData) {
                        final message = snapshot.data;
                        if (message == null || message.isEmpty) {
                          return Text("(No Message)", style: textStyle);
                        }
                        return Text(
                          snapshot.data!,
                          style: textStyle,
                        );
                      }
                      return Text("...", style: textStyle);
                    },
                  )
                ],
              ),
            ),
            Text(
              formatDate(widget.room),
            ),
          ],
        ),
      ),
    );
  }

  String formatDate(types.Room room) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(room.updatedAt!);
    final dateFormat = DateFormat('E MM, hh:mm');

    return dateFormat.format(dateTime);
  }
}
