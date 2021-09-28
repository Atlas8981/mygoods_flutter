import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:mygoods_flutter/models/item.dart';
import 'package:mygoods_flutter/services/database_service.dart';
import 'package:mygoods_flutter/views/cells/list_product_row.dart';

class ListProduct extends StatefulWidget {
  const ListProduct({Key? key}) : super(key: key);

  @override
  _ListProductState createState() => _ListProductState();
}



class _ListProductState extends State<ListProduct> {
  // final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    DatabaseService databaseService = DatabaseService();

    // print(Get.arguments[0]);
    // print(Get.arguments[1]);
    // print(Get.arguments);

    return Scaffold(
      appBar: AppBar(
        title: Text(Get.arguments[1]),
      ),
      body: SafeArea(
        child: FutureBuilder<List<Item>>(
          future: databaseService.getItems(Get.arguments[0].toString(),Get.arguments[1].toString()),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text('An error has occurred!'),
              );
            } else if (snapshot.hasData) {
              if(snapshot.data != null) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return ListItemRow(item: snapshot.data![index]);
                  },
                );
              }return Text("n error has occurred");

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
