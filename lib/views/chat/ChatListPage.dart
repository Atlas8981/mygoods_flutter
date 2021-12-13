import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mygoods_flutter/components/ListBottomSheet.dart';
import 'package:mygoods_flutter/utils/constant.dart';

class ChatListPage extends StatelessWidget {
  const ChatListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chats"),
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

              // Get.bottomSheet(
              //   ListButtonSheet(
              //     items: ["something"],
              //     onItemClick: (index) {
              //
              //     },
              //   ),
              // );
            },
            icon: Icon(Icons.filter_list),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: ListView.builder(
          itemCount: 2,
          itemBuilder: (context, index) {
            return ChatRow();
          },
        ),
      ),
    );
  }
}

class ChatRow extends StatelessWidget {
  const ChatRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
                            fontSize: 12, color: Colors.black.withOpacity(0.8)),
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
    );
  }
}
