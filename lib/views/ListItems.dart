import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mygoods_flutter/models/item.dart';
import 'package:mygoods_flutter/services/item_database_service.dart';
import 'package:mygoods_flutter/views/cells/list_product_row.dart';

class ListItem extends StatefulWidget {
  const ListItem({
    Key? key,
    required this.mainCat,
    required this.subCat,
  }) : super(key: key);

  final String mainCat, subCat;

  @override
  _ListItemState createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  final ItemDatabaseService databaseService = ItemDatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.subCat),
      ),
      body: SafeArea(
          child: FutureBuilder<List<Item>>(
        future: databaseService.getItems(widget.mainCat, widget.subCat),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('An error has occurred!'),
            );
          } else if (snapshot.hasData) {
            if (snapshot.data != null) {
              return Container(
                padding: const EdgeInsets.all(10),
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return ListItemRow(item: snapshot.data![index]);
                  },
                ),
              );
            }
            return Text("an error has occurred");
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      )

          // FutureBuilder<QuerySnapshot>(
          //   future: itemsCollection.limit(1).get(),
          //   builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot) {
          //     String result = "";
          //     if (snapshot.hasError) {
          //       return Text("Something went wrong");
          //     }
          //
          //     if (snapshot.connectionState == ConnectionState.done) {
          //       snapshot.data!.docs.forEach((doc) {
          //         result += "${doc["name"]}\n";
          //       });
          //     }
          //
          //     //
          //     //
          //     // itemsCollection.get().then((QuerySnapshot querySnapshot) {
          //     //   // return querySnapshot;
          //     //   querySnapshot.docs.forEach((doc) {
          //     //     Text(doc["name"]);
          //     //   });
          //     //   return querySnapshot;
          //     // });
          //     return Text(
          //         result.isEmpty ?
          //             "Loading"
          //             : result
          //     );
          //   },
          // ),
          ),
    );
  }
}
