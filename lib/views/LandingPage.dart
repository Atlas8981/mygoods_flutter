import 'dart:async';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mygoods_flutter/components/TypeTextField.dart';
import 'package:mygoods_flutter/models/ModelProvider.dart';
import 'package:mygoods_flutter/utils/constant.dart';

import '../amplifyconfiguration.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final AmplifyDataStore _dataStorePlugin = AmplifyDataStore(
    modelProvider: ModelProvider.instance,
  );

  late StreamSubscription<QuerySnapshot<Item>> _subscription;

  final textController = TextEditingController();

  List<Item> items = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Amplify Flutter"),
        actions: [
          IconButton(
            onPressed: () {
              saveItem().then((value) => showToast("Done"));
            },
            icon: Icon(Icons.add),
          ),
          IconButton(
            onPressed: () {
              updateItem();
            },
            icon: Icon(Icons.edit),
          ),
          TextButton(
            onPressed: () {
              getAllItem();
            },
            child: Text(
              "GetAll",
              style: TextStyle(color: Colors.white),
            ),
          ),
          IconButton(
            onPressed: () {
              syncData();
            },
            icon: Icon(Icons.sync),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            TypeTextField(
              labelText: "labelText",
              controller: textController,
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await _configureAmplify();

    // after configuring Amplify, update loading ui state to loaded state
    // setState(() {
    //   _isLoading = false;
    // });
    _subscription = Amplify.DataStore.observeQuery(Item.classType)
        .listen((QuerySnapshot<Item> snapshot) {
      items = snapshot.items;
      showToast(items.map((e) => e.name).toString());
      // setState(() {
      //   // if (_isLoading) _isLoading = false;
      //   _todos = snapshot.items;
      // });
    });
  }

  Future<void> _configureAmplify() async {
    try {
      // add Amplify plugins
      await Amplify.addPlugins([_dataStorePlugin]);
      await Amplify.addPlugin(AmplifyAPI(modelProvider: ModelProvider.instance));
      // configure Amplify
      //
      // note that Amplify cannot be configured more than once!
      if (!Amplify.isConfigured) {
        await Amplify.configure(amplifyconfig);
      }
    } catch (e) {
      // error handling can be improved for sure!
      // but this will be sufficient for the purposes of this tutorial
      print('An error occurred while configuring Amplify: $e');
    }
  }

  Future<void> saveItem() async {
    // get the current text field contents
    String name = textController.text;

    // create a new Item from the form values
    // `isComplete` is also required, but should start false in a new Todo
    final item = Item(
      name: name,
    );

    try {
      // to write data to DataStore, we simply pass an instance of a model to
      // Amplify.DataStore.save()
      await Amplify.DataStore.save(item);

      // after creating a new
      Get.back();
    } catch (e) {
      print('An error occurred while saving Todo: $e');
    }
  }

  Future<void> getAllItem() async {
    try {
      // items = await Amplify.DataStore.query(Item.classType);
      Amplify.DataStore.observeQuery(Item.classType).listen((event) {
        for (var element in event.items) {
          print(element.name);
        }
        items = event.items;
      });
    } catch (e) {
      print('An error occurred while saving: $e');
    }
  }

  Future<void> updateItem() async {
    Item updatedItem = items[items.length - 1].copyWith(name: "Soemthing new");

    try {
      await Amplify.DataStore.save(updatedItem);
    } catch (e) {
      print('An error occurred while saving Todo: $e');
    }
  }

  Future<void> syncData() async {
    await Amplify.DataStore.start();
  }
}
