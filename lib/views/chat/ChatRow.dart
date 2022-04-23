import 'package:avatars/avatars.dart';
import 'package:extended_image/extended_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mygoods_flutter/utils/constant.dart';
import 'package:mygoods_flutter/views/chat/ChatRoom.dart';

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
            ? ExtendedResizeImage(
                ExtendedNetworkImageProvider(
                  room.imageUrl ?? dummyNetworkImage,
                  cache: true,
                ),
                compressionRatio: 1 / 3,
              )
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
                    borderRadius: BorderRadius.all(
                      Radius.circular(30),
                    ),
                  ),
                ),
              )
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final room = widget.room;
    return InkWell(
      onTap: () {
        Get.to(
          () => ChatRoom(
            room: room,
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
            _buildAvatar(room),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    room.name ?? '',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  FutureBuilder<String>(
                    future: getLastMessage(room),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final message = snapshot.data;
                        if (message == null || message.isEmpty) {
                          return Text("(${"noMessage".tr})");
                        }
                        return Text(snapshot.data!);
                      }
                      return const Text("...");
                    },
                  )
                ],
              ),
            ),
            Text(formatDate(room.updatedAt ?? 0)),
          ],
        ),
      ),
    );
  }
}
