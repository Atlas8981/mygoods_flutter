import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mygoods_flutter/components/ClickableTextField.dart';
import 'package:mygoods_flutter/components/TypeTextField.dart';
import 'package:mygoods_flutter/controllers/addImagesController.dart';
import 'package:mygoods_flutter/models/category.dart';
import 'package:mygoods_flutter/utils/constant.dart';

class AddPage extends StatefulWidget {
  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final addImageController = Get.put(AddImageController());
  final key = GlobalKey<AnimatedListState>();

  // XFile? image;

  ImagePicker _imagePicker = ImagePicker();

  String subCat = "", mainCat = "", condition = "";
  TextEditingController nameCon = TextEditingController(),
      priceCon = TextEditingController(),
      addressCon = TextEditingController(),
      phoneCon = TextEditingController(),
      descriptionCon = TextEditingController(),
      categoryCon = TextEditingController()
  ;

  void _imageFromGallery(index) async {
    // var picture = await _imagePicker.pick(source: ImageSource.gallery);

    var pictures = await _imagePicker.pickMultiImage();
    if (pictures != null && pictures.length <= 5) {
      setState(() {
        // image = picture;
        // key.currentState!.insertItem(index+1);
        pictures.forEach((picture) {
          addImageController.rawImages.add(picture);
        });
      });
    } else {
      Fluttertoast.showToast(
          msg: "Select Less than 5 Images",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
      // Get.snackbar(
      //     "Lers Image", "Select Less than 5 Images",
      //   backgroundColor: Colors.white,
      //   snackPosition: SnackPosition.BOTTOM
      // );
    }
  }

  buildAddImageRow(context, index) {
    if (index < addImageController.rawImages.length &&
        addImageController.rawImages[index].path != null) {
      return Container(
        padding: EdgeInsets.all(5),
        child: Stack(children: [
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
    } else {
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
              child: Obx(() {
                return Text(
                  "(${addImageController.rawImages.length}/5)",
                  style: TextStyle(fontSize: 16),
                );
              }),
            ),
            //Horizontal Image View
            Container(
              height: 120,
              child: Obx(() {
                return ListView.builder(
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
              }),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              // mainAxisAlignment: MainAxisAlignment,
              children: [
                Expanded(
                  child: TypeTextField(
                    labelText: "Item Name",
                    controller: nameCon,
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: TypeTextField(
                    labelText: "Price",
                    controller: priceCon,
                    suffixIcon:
                        Icon(Icons.attach_money, color: context.iconColor
                            // color: Colors.black,
                            ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            ClickableTextField(
              labelText: "Category",
              controller: categoryCon,
              suffixIcon: Icon(
                Icons.arrow_forward_ios,
                color: context.iconColor,
              ),
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
                Get.defaultDialog(
                  title: "Select Category",
                  content: Container(
                    // color: Colors.red,
                    width: double.infinity,
                    child: CategoryDropdownMenu(
                      onConfirm: (main, sub) {
                        categoryCon.text = "$main , $sub";
                      },
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

class CategoryDropdownMenu extends StatefulWidget {
  const CategoryDropdownMenu({Key? key, this.onConfirm}) : super(key: key);

  final Function(String main, String sub)? onConfirm;

  @override
  _CategoryDropdownMenuState createState() => _CategoryDropdownMenuState();
}

class _CategoryDropdownMenuState extends State<CategoryDropdownMenu> {
  String mainCategory = mainCategories[0].name;

  // String? subCategory;
  String? subCategory;
  List<Category>? subCategories;

  findSubCategory() {
    if (mainCategory == mainCategories[0].name) {
      subCategories = electronicSubCategories;
      subCategory = electronicSubCategories[0].name;
    } else if (mainCategory == mainCategories[1].name) {
      subCategories = carSubCategories;
      subCategory = carSubCategories[0].name;
    } else {
      subCategories = furnitureSubCategories;
      subCategory = furnitureSubCategories[0].name;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (subCategories == null) {
      subCategories = electronicSubCategories;
    }
    if (subCategory == null) {
      subCategory = electronicSubCategories[0].name;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Main Category"),
        DropdownButton<String>(
          value: mainCategory,
          isExpanded: true,
          items: mainCategories.map((value) {
            return DropdownMenuItem<String>(
              value: value.name,
              child: Text(value.name),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              mainCategory = value!;
              findSubCategory();
            });
          },
        ),
        Text("Sub Category"),
        DropdownButton<String>(
          value: subCategory,
          isExpanded: true,
          items: subCategories!.map((value) {
            return DropdownMenuItem<String>(
              value: value.name,
              child: Text(value.name),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                subCategory = value;
              });
            }
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
                onPressed: () {
                  Get.back();
                },
                child: Text("Cancel")),
            TextButton(
              onPressed: () {
                Get.back();
                if (widget.onConfirm != null) {
                  if (subCategory != null) {
                    widget.onConfirm!(mainCategory, subCategory!);
                  }
                }
              },
              child: Text("Confirm"),
            ),
          ],
        )
      ],
    );
  }
}
