import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mygoods_flutter/controllers/addImagesController.dart';

class AddPage extends StatefulWidget {
  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final addImageController = Get.put(AddImageController());
  final key = GlobalKey<AnimatedListState>();
  // XFile? image;

  ImagePicker _imagePicker = ImagePicker();

  void _imageFromGallery(index) async {
    // var picture = await _imagePicker.pick(source: ImageSource.gallery);

    var pictures = await _imagePicker.pickMultiImage();
    if (pictures != null && pictures.length<=5) {
      setState(() {
        // image = picture;
        // key.currentState!.insertItem(index+1);
        pictures.forEach((picture) {
          addImageController.rawImages.add(picture);
        });
      });
    }else{
      Fluttertoast.showToast(
          msg: "Select Less than 5 Images",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0
      );
      // Get.snackbar(
      //     "Lers Image", "Select Less than 5 Images",
      //   backgroundColor: Colors.white,
      //   snackPosition: SnackPosition.BOTTOM
      // );
    }
  }

  buildAddImageRow(context, index){
    if (index< addImageController.rawImages.length
        && addImageController.rawImages[index].path != null ) {
      return Container(
        padding: EdgeInsets.all(5),
        child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () {
                    print('I click on Image');
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.file(
                      File(addImageController.rawImages[index].path),
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              //Delete Button
              Positioned(
                top: 5,
                right: 5,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      addImageController.rawImages.removeAt(index);
                      // key.currentState!.removeItem(index, (context, animation) => buildAddImageRow(context, index));
                    });
                  },
                  child: Icon(
                    Icons.indeterminate_check_box_outlined,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ]),
      );
    }else {
      return Card(
        elevation: 3,
        child: Container(
          width: 120,
          height: 120,
          padding: EdgeInsets.all(5),
          child: IconButton(
            onPressed: () {
              _imageFromGallery(index);
            },
            icon: Icon(
              Icons.add,
              size: 48,
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.all(10),
      // color: Colors.cyanAccent,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Upload Photos",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Obx((){
                return Text(
                  "(${addImageController.rawImages.length}/5)",
                  style: TextStyle(fontSize: 16),
                );
              }),
            ),
            Container(
                height: 120,
                child: Obx(() {
                  return ListView.builder(
                    key: key,
                    scrollDirection: Axis.horizontal,
                    itemCount: addImageController.rawImages.length + 1,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return buildAddImageRow(context, index);
                    },
                  );
                  // return AnimatedList(
                  //   key: key,
                  //   scrollDirection: Axis.horizontal,
                  //   initialItemCount: addImageController.rawImages.length + 1,
                  //   shrinkWrap: true,
                  //   itemBuilder: (context, index,controller) {
                  //     return buildAddImageRow(context, index);
                  //   },
                  // );
                })),
          ],
        ),
      ),
    );
  }
}

class AddImageCell extends StatefulWidget {
  const AddImageCell({Key? key}) : super(key: key);

  @override
  _AddImageCellState createState() => _AddImageCellState();
}

class _AddImageCellState extends State<AddImageCell> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Container(
        width: 120,
        height: 120,
        child: IconButton(
          onPressed: () {
            // _imageFromGallery();
          },
          icon: Icon(
            Icons.add,
            size: 48,
          ),
        ),
      ),
    );
  }
}

class HasImageCell extends StatelessWidget {
  const HasImageCell({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Align(
        alignment: Alignment.center,
        child: GestureDetector(
          onTap: () {
            print('I click on Image');
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image(
              image: AssetImage("assets/images/bikepicture.jpg"),
              width: 120,
              height: 120,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      Align(
        alignment: Alignment.topLeft,
        child: GestureDetector(
          onTap: () {
            // setState(() {
            //   shopImage = null;
            // });
          },
          child: SizedBox(
              width: 36, height: 36, child: Icon(Icons.cancel_outlined)),
        ),
      ),
    ]);
  }
}
