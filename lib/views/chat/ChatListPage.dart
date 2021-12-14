import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:get/get.dart';
import 'package:mygoods_flutter/utils/constant.dart';
import 'package:mygoods_flutter/views/chat/ChatRoom.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'UserListPage.dart';

class ChatListPage extends StatefulWidget {
  ChatListPage({Key? key}) : super(key: key);

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  final fireChatCore = FirebaseChatCore.instance;

  final auth = FirebaseAuth.instance;
  late types.User _user = types.User(id: auth.currentUser!.uid);

  Widget _buildAvatar(types.Room room) {
    var color = Colors.transparent;

    if (room.type == types.RoomType.direct) {
      try {
        final otherUser = room.users.firstWhere(
          (u) => u.id != _user.id,
        );

        color = getUserAvatarNameColor(otherUser);
      } catch (e) {
        // Do nothing if other user is not found
      }
    }

    final hasImage = room.imageUrl != null;
    final name = room.name ?? '';

    return Container(
      margin: const EdgeInsets.only(right: 16),
      child: CircleAvatar(
        backgroundColor: hasImage ? Colors.transparent : color,
        backgroundImage:
            hasImage ? CachedNetworkImageProvider(room.imageUrl!) : null,
        radius: 30,
        child: !hasImage
            ? Text(
                name.isEmpty ? '' : name[0].toUpperCase(),
                style: const TextStyle(color: Colors.white),
              )
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat List"),
        actions: [
          IconButton(
            onPressed: () {
              showCupertinoModalPopup(
                context: context,
                builder: (context) {
                  return CupertinoActionSheet(
                    actions: [
                      CupertinoActionSheetAction(
                        child: Text("All"),
                        onPressed: () {},
                      ),
                      CupertinoActionSheetAction(
                        child: Text("Buy"),
                        onPressed: () {},
                      ),
                      CupertinoActionSheetAction(
                        child: Text("Sell"),
                        onPressed: () {},
                      ),
                      CupertinoActionSheetAction(
                        child: Text("Unread"),
                        onPressed: () {},
                      ),
                      CupertinoActionSheetAction(
                        child: Text("Block User"),
                        onPressed: () {},
                      ),
                    ],
                    cancelButton: CupertinoActionSheetAction(
                      child: Text("Cancel"),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  );
                },
              );
            },
            icon: Icon(Icons.filter_list),
          ),
          IconButton(
            onPressed: () {
              Get.to(() => UserListPage());
            },
            icon: Icon(Icons.person_add),
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

              return InkWell(
                onTap: () {
                  Get.to(() => ChatRoom(
                        room: room,
                      ));
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      _buildAvatar(room),
                      Text(room.name ?? ''),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ChatRow extends StatelessWidget {
  const ChatRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        height: 100,
        // color: Colors.red,
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(dummyNetworkImage),
              radius: 40,
            ),
            SizedBox(
              width: 8,
            ),
            Expanded(
              child: Container(
                // color: Colors.blue,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("(Atlas 5951)"),
                        Text(
                          "(22 June 2021)",
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.black.withOpacity(0.8)),
                        ),
                      ],
                    ),
                    Text(
                      "(Disc Brake Rotor Snails)",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "(Item Status) This item is not available",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      "(Last Text) How Much?",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 8,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                dummyNetworkImage,
                height: 80,
                width: 80,
                fit: BoxFit.cover,
              ),
            )
          ],
        ),
      ),
    );
  }
}
