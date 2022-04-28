import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:mygoods_flutter/controllers/HomePageController.dart';
import 'package:mygoods_flutter/services/HomePageService.dart';
import 'package:mygoods_flutter/views/search/ItemSearchDelegate.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final homePageService = HomePageService();

  final homePageController = Get.put(HomePageController());
  final functions = FirebaseFunctions.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("home".tr),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: ItemSearchDelegate(),
              );
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      //WORK on PHONE not emulators
      body: ModelViewer(
        backgroundColor: const Color.fromARGB(0xFF, 0xEE, 0xEE, 0xEE),
        src: 'assets/models/optimus.glb', // a bundled asset file
        alt: "A 3D models of an astronaut",
        ar: true,
        arModes: const ['scene-viewer', 'webxr', 'quick-look'],
        autoRotate: true,
        cameraControls: true,
      ),
    );
  }

}
