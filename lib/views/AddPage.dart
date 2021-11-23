import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mygoods_flutter/components/ClickableTextField.dart';
import 'package:mygoods_flutter/components/TypeTextField.dart';
import 'package:mygoods_flutter/controllers/addImagesController.dart';
import 'package:mygoods_flutter/models/additionalInfo.dart';
import 'package:mygoods_flutter/models/category.dart';
import 'package:mygoods_flutter/models/image.dart' as myImageClass;
import 'package:mygoods_flutter/models/item.dart';
import 'package:mygoods_flutter/services/additional_data_service.dart';
import 'package:mygoods_flutter/utils/constant.dart';
import 'package:mygoods_flutter/views/WelcomePage.dart';

class AddPage extends StatefulWidget {
  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final FirebaseStorage storage = FirebaseStorage.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final AdditionalDataService additionalDataService = AdditionalDataService();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final addImageController = Get.put(AddImageController());
  final key = GlobalKey<AnimatedListState>();

  final conditions = ["New", "Used"];

  final ImagePicker _imagePicker = ImagePicker();

  String subCat = "", mainCat = "", condition = "";
  final TextEditingController nameCon = TextEditingController(),
      priceCon = TextEditingController(),
      addressCon = TextEditingController(),
      phoneCon = TextEditingController(),
      descriptionCon = TextEditingController(),
      categoryCon = TextEditingController(),
      additionalInfoCon = TextEditingController(),
      conditionCon = TextEditingController();

  final List<Car> carList = [];

  bool showAdditionInfoForm() {
    final hasAdditionInfo = hasAdditionalInfoList.contains(subCat);
    if (hasAdditionInfo) {
      additionalDataService.getCarData().then((value) {
        if (value != null) {
          setState(() {
            carList.clear();
            carList.addAll(value);
          });
        }
      });
    }
    return hasAdditionInfo;
  }

  void carProcedure() async {
    String selectBrand = "";
    String selectModel = "";
    String selectType = "";
    String selectYear = "";

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return CustomBottomSheetWithSearch(
            items: carList.map((e) => e.brand).toSet().toList(),
            onTapItem: (value) {
              selectBrand = value;
              Get.back();
            },
          );
        });

    if (selectBrand.isEmpty) {
      return;
    }
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return CustomBottomSheetWithSearch(
            items: carList
                .map((e) => (e.brand == selectBrand) ? e.model : "Other")
                .toSet()
                .toList(),
            onTapItem: (value) {
              selectModel = value;
              Get.back();
              setState(() {});
              // print(value);
            },
          );
        });
    if (selectModel.isEmpty) {
      return;
    }
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return CustomBottomSheetWithSearch(
            items: carList
                .map((e) => (e.brand == selectBrand && e.model == selectModel)
                    ? e.category
                    : "Other")
                .toSet()
                .toList(),
            onTapItem: (value) {
              selectType = value;
              Get.back();
              setState(() {});
              // print(value);
            },
          );
        });
    if (selectType.isEmpty) {
      return;
    }
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return CustomBottomSheetWithSearch(
            items: carList
                .map((e) => (e.brand == selectBrand &&
                        e.model == selectModel &&
                        e.category == selectType)
                    ? e.year
                    : "Other")
                .toSet()
                .toList(),
            onTapItem: (value) {
              selectYear = value;
              additionalInfoCon.text =
                  "$selectBrand, $selectModel, $selectType, $selectYear";
              Get.back();
              setState(() {});
              // print(value);
            },
          );
        });
  }

  void phoneProcedure() async {
    String selectBrand = "";
    String selectModel = "";
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return CustomBottomSheetWithSearch(
            items: carList.map((e) => e.brand).toSet().toList(),
            onTapItem: (value) {
              selectBrand = value;
              Get.back();
              // setState(() {});
              // print(value);
            },
          );
        });

    if (selectBrand.isEmpty) {
      return;
    }
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return CustomBottomSheetWithSearch(
            items: carList
                .map((e) => (e.brand == selectBrand) ? e.model : "Other")
                .toSet()
                .toList(),
            onTapItem: (value) {
              selectModel = value;
              Get.back();
              setState(() {});
              // print(value);
            },
          );
        });
  }

  void processAdditionalInformation() {
    // electronicSubCategories[0].name,
    // electronicSubCategories[3].name,
    // carSubCategories[0].name,
    // carSubCategories[1].name,
    // carSubCategories[2].name,
    if (subCat.capitalize == hasAdditionalInfoList[0]) {
      // phoneProcedure();
      showToast("Mok Dol Luv Hz");
    } else if (subCat.capitalize == hasAdditionalInfoList[1]) {
      // partAccessoriesComputerProcedure();
      showToast("Mok Dol Luv Hz");
    } else if (subCat.capitalize == hasAdditionalInfoList[2]) {
      carProcedure();
    } else if (subCat.capitalize == hasAdditionalInfoList[3]) {
      // motoProcedure();
      showToast("Mok Dol Luv Hz");
    } else if (subCat.capitalize == hasAdditionalInfoList[4]) {
      // bikeProcedure();
      showToast("Mok Dol Luv Hz");
    }
  }

  void _imageFromGallery(index) async {
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
              child: Card(
                margin: EdgeInsets.all(0),
                elevation: 5,
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

  Future<List<myImageClass.Image>> uploadFiles(List<File> _images) async {
    var images = await Future.wait(_images.map((_image) => uploadFile(_image)));
    // print(images);
    return images;
  }

  Future<myImageClass.Image> uploadFile(File _image) async {
    final imageName = "${DateTime.now()}";
    final Reference storageReference =
        storage.ref('flutter/').child("$imageName");
    await storageReference.putFile(_image);
    final imageUrl = await storageReference.getDownloadURL();
    final image = myImageClass.Image(imageName: imageName, imageUrl: imageUrl);
    return image;
  }

  final String collectionName = "items";

  void uploadData(List<myImageClass.Image> imageUrls) {
    final CollectionReference reference =
        FirebaseFirestore.instance.collection("$collectionName");

    final String id =
        reference.doc().path.toString().replaceAll("$collectionName/", "");

    final Item item = Item(
        date: Timestamp.now(),
        subCategory: subCat,
        images: imageUrls,
        amount: 0,
        address: addressCon.text,
        description: descriptionCon.text,
        userid: "auth.uid",
        itemid: id,
        viewers: [],
        phone: phoneCon.text,
        price: double.parse(priceCon.text),
        name: nameCon.text,
        mainCategory: mainCat,
        views: 0);

    reference.doc(id).set(item.toJson()).then((value) {
      print("success");
      showToast("Success");
      clearData();
    }).catchError((error) {
      print("Failed with error: $error");
    });
  }

  Future<void> uploadItemInformation() async {
    uploadFiles(addImageController.getRawImageInFile()).then((images) {
      uploadData(images);
    });
  }

  void clearData() {
    subCat = "";
    mainCat = "";
    categoryCon.text = "";
    addressCon.text = "";
    descriptionCon.text = "";
    phoneCon.text = "";
    priceCon.text = "";
    nameCon.text = "";
    conditionCon.text = "";
    condition = "";
    addImageController.rawImages.clear();
    setState(() {
      formKey = GlobalKey<FormState>();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Page"),
        actions: [
          IconButton(
              onPressed: () {
                clearData();
              },
              tooltip: "Clear Data",
              icon: Icon(Icons.refresh)),
          IconButton(
              onPressed: () {
                // uploadFile("filePath");
                if (!formKey.currentState!.validate()) {
                  // showToast("message");
                  return;
                }
                uploadItemInformation();
              },
              icon: Icon(Icons.check)),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              //Top Text in Horizontal Imageview
              Column(
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
                ],
              ),
              //Horizontal Image View
              Container(
                height: 120,
                child: Obx(() {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: (addImageController.rawImages.length == 5)
                        ? 5
                        : addImageController.rawImages.length + 1,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return buildAddImageRow(context, index);
                    },
                  );
                }),
              ),
              SizedBox(
                height: 10,
              ),

              //Forms
              Form(
                key: formKey,
                child: Column(
                  children: [
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
                            inputType: TextInputType.numberWithOptions(
                                decimal: true, signed: false),
                            suffixIcon: Icon(Icons.attach_money,
                                color: context.iconColor
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
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              titlePadding: EdgeInsets.all(10),
                              contentPadding: EdgeInsets.all(10),
                              actionsPadding: EdgeInsets.all(10),
                              title: Text("Select Category"),
                              content: CategoryDropdownMenu(
                                onConfirm: (main, sub) {
                                  categoryCon.text = "$main , $sub";
                                  mainCat = main;
                                  subCat = sub;
                                  setState(() {});
                                },
                              ),
                            );
                          },
                        );
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Visibility(
                      visible: showAdditionInfoForm(),
                      maintainSize: false,
                      child: Column(
                        children: [
                          ClickableTextField(
                            labelText: "Enter ${subCat.capitalize} Information",
                            controller: additionalInfoCon,
                            suffixIcon: Icon(
                              Icons.arrow_forward_ios,
                              color: context.iconColor,
                            ),
                            onTap: () async {
                              FocusScope.of(context).requestFocus(FocusNode());
                              processAdditionalInformation();
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                    ClickableTextField(
                      labelText: "Condition",
                      controller: conditionCon,
                      suffixIcon: Icon(
                        Icons.arrow_forward_ios,
                        color: context.iconColor,
                      ),
                      onTap: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        Get.bottomSheet(
                            CustomButtonSheet(
                              items: conditions,
                              onItemClick: (index) {
                                print(conditions[index]);
                                setState(() {
                                  conditionCon.text = conditions[index];
                                });
                              },
                            ),
                            backgroundColor: Colors.white);
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TypeTextField(
                      labelText: "Address",
                      controller: addressCon,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TypeTextField(
                      labelText: "Phone Number",
                      controller: phoneCon,
                      inputType: TextInputType.phone,
                      prefix: "0",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Field Empty";
                        }
                        if (!GetUtils.isPhoneNumber("0$value")) {
                          return "Wrong Phone Format";
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: descriptionCon,
                      maxLength: 200,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                      decoration: InputDecoration(
                          alignLabelWithHint: true,
                          contentPadding: EdgeInsets.all(10),
                          labelStyle: TextStyle(
                            fontSize: 16,
                          ),
                          labelText: "Description",
                          border: OutlineInputBorder(),
                          counterStyle: TextStyle(fontSize: 12, height: 1)),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomBottomSheetWithSearch extends StatefulWidget {
  const CustomBottomSheetWithSearch(
      {Key? key,
      this.scrollController,
      this.bottomSheetOffset,
      required this.onTapItem,
      required this.items})
      : super(key: key);

  final ScrollController? scrollController;
  final double? bottomSheetOffset;
  final Function(String value) onTapItem;
  final List<String> items;

  @override
  _CustomBottomSheetWithSearchState createState() =>
      _CustomBottomSheetWithSearchState();
}

class _CustomBottomSheetWithSearchState
    extends State<CustomBottomSheetWithSearch> {
  List<String> _tempList = [];

  late List<String> _listOfItems = widget.items;
  final TextEditingController searchFieldCon = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
        expand: false,
        // initialChildSize: 0.5,
        maxChildSize: 0.9,
        // minChildSize: 0.5,

        builder: (BuildContext context, ScrollController scrollController) {
          return Container(
            padding: EdgeInsets.all(20),
            child: Column(children: <Widget>[
              Row(children: <Widget>[
                Expanded(
                    child: TextField(
                        controller: searchFieldCon,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(8),
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(15.0),
                            borderSide: new BorderSide(),
                          ),
                          prefixIcon: Icon(Icons.search),
                        ),
                        onChanged: (value) {
                          //4
                          setState(() {
                            _tempList = _buildSearchList(value);
                          });
                        })),
                IconButton(
                    padding: EdgeInsets.all(0),
                    icon: Icon(
                      Icons.close,
                      size: 28,
                    ),
                    // color: Color(0xFF1F91E7),
                    onPressed: () {
                      setState(() {
                        searchFieldCon.clear();
                        _tempList.clear();
                      });
                    }),
              ]),
              Expanded(
                child: Container(
                  child: ListView.builder(
                      controller: scrollController,
                      // physics: const NeverScrollableScrollPhysics(),
                      //5
                      shrinkWrap: true,
                      itemCount: (_tempList.length > 0)
                          ? _tempList.length
                          : _listOfItems.length,
                      // separatorBuilder: (context, int) {
                      //   return Divider();
                      // },
                      itemBuilder: (context, index) {
                        return InkWell(

                            //6
                            child: (_tempList.length > 0)
                                ? _showBottomSheetWithSearch(index, _tempList)
                                : _showBottomSheetWithSearch(
                                    index, _listOfItems),
                            onTap: () {
                              widget.onTapItem((_tempList.length > 0)
                                  ? _tempList[index]
                                  : _listOfItems[index]);
                            });
                      }),
                ),
              ),
            ]),
          );
        });
  }

  //8
  Widget _showBottomSheetWithSearch(int index, List<String> listOfCities) {
    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      child: Text(listOfCities[index],
          style: TextStyle(fontSize: 16, fontFamily: 'KhmerOSBattambang'),
          // style: TextStyle(color: Colors.black, fontSize: 18),
          textAlign: TextAlign.start),
    );
  }

  //9
  List<String> _buildSearchList(String userSearchTerm) {
    List<String> _searchList = [];

    for (int i = 0; i < _listOfItems.length; i++) {
      String name = _listOfItems[i];
      if (name.toLowerCase().contains(userSearchTerm.toLowerCase())) {
        _searchList.add(_listOfItems[i]);
      }
    }
    return _searchList;
  }
}

class CustomButtonSheet extends StatefulWidget {
  const CustomButtonSheet({
    Key? key,
    required this.items,
    required this.onItemClick,
  }) : super(key: key);

  final List<String> items;
  final Function(int index) onItemClick;

  @override
  _CustomButtonSheetState createState() => _CustomButtonSheetState();
}

class _CustomButtonSheetState extends State<CustomButtonSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: widget.items.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              widget.onItemClick(index);
              Get.back();
            },
            child: Container(
              padding: EdgeInsets.all(10),
              child: Text(
                widget.items[index],
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
            ),
          );
        },
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
      mainAxisSize: MainAxisSize.min,
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
