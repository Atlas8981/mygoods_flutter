import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mygoods_flutter/components/CategoryDropdownMenu.dart';
import 'package:mygoods_flutter/components/ClickableTextField.dart';
import 'package:mygoods_flutter/components/CustomBottomSheet.dart';
import 'package:mygoods_flutter/components/TypeTextField.dart';
import 'package:mygoods_flutter/controllers/itemFormController.dart';
import 'package:mygoods_flutter/models/additionalInfo.dart';
import 'package:mygoods_flutter/services/additional_data_service.dart';
import 'package:mygoods_flutter/utils/constant.dart';

class ItemForm extends StatefulWidget {
  const ItemForm({
    Key? key,
    this.padding,
    this.titleText,
    this.onConfirm,
  }) : super(key: key);

  final EdgeInsets? padding;
  final Widget? titleText;
  final Function()? onConfirm;

  @override
  _ItemFormState createState() => _ItemFormState();
}

class _ItemFormState extends State<ItemForm> {
  final AdditionalDataService additionalDataService = AdditionalDataService();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // final addImageController = Get.put(AddImageController());
  final itemFormCon = Get.put(ItemFormController());
  final key = GlobalKey<AnimatedListState>();

  final conditions = ["New", "Used"];

  final ImagePicker _imagePicker = ImagePicker();

  // String subCat = "", mainCat = "", condition = "";

  final List<Car> carList = [];

  bool showAdditionInfoForm(String subCat) {
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
              itemFormCon.additionalInfoCon.text =
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
    if (itemFormCon.subCat.value.capitalize == hasAdditionalInfoList[0]) {
      // phoneProcedure();
      showToast("Mok Dol Luv Hz");
    } else if (itemFormCon.subCat.value.capitalize == hasAdditionalInfoList[1]) {
      // partAccessoriesComputerProcedure();
      showToast("Mok Dol Luv Hz");
    } else if (itemFormCon.subCat.value.capitalize == hasAdditionalInfoList[2]) {
      carProcedure();
    } else if (itemFormCon.subCat.value.capitalize == hasAdditionalInfoList[3]) {
      // motoProcedure();
      showToast("Mok Dol Luv Hz");
    } else if (itemFormCon.subCat.value.capitalize == hasAdditionalInfoList[4]) {
      // bikeProcedure();
      showToast("Mok Dol Luv Hz");
    }
  }

  void _imageFromGallery(index) async {
    var pictures = await _imagePicker.pickMultiImage();
    if (pictures != null && pictures.length <= 5) {
      setState(() {
        pictures.forEach((picture) {
          itemFormCon.rawImages.add(picture);
        });
      });
    } else {
      showToast("Select Less than 5 Images");
    }
  }

  buildAddImageRow(context, index) {
    final tempRawImages = itemFormCon.rawImages;
    if (index < tempRawImages.length && tempRawImages[index].path != null) {
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
                    File(tempRawImages[index].path),
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
                  tempRawImages.removeAt(index);
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

  // Item processData(){
  //   final Item item = Item(
  //       date: date,
  //       subCategory: subCategory,
  //       images: images,
  //       amount: amount,
  //       address: address,
  //       description: description,
  //       userid: userid,
  //       itemid: itemid,
  //       viewers: viewers,
  //       phone: phone,
  //       price: price,
  //       name: name,
  //       mainCategory: mainCategory,
  //       views: views);
  //   return item;
  // }

  buildTextInputForm() {
    return GetBuilder<ItemFormController>(
      // init: itemFormCon,
      builder: (controller) {
        return Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              // mainAxisAlignment: MainAxisAlignment,
              children: [
                Expanded(
                  child: TypeTextField(
                    labelText: "Item Name",
                    controller: controller.nameCon,
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: TypeTextField(
                    labelText: "Price",
                    controller: controller.priceCon,
                    inputType: TextInputType.numberWithOptions(
                        decimal: true, signed: false),
                    suffixIcon: Icon(Icons.attach_money, color: context.iconColor
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
              controller: controller.categoryCon,
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
                          controller.categoryCon.text = "$main , $sub";
                          itemFormCon.mainCat.value = main;
                          itemFormCon.subCat.value = sub;
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
              visible: showAdditionInfoForm(controller.subCat.value),
              maintainSize: false,
              child: Column(
                children: [
                  ClickableTextField(
                    labelText: "Enter ${itemFormCon.subCat.value.capitalize} Information",
                    controller: controller.additionalInfoCon,
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
              controller: controller.conditionCon,
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
                          controller.conditionCon.text = conditions[index];
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
              controller: controller.addressCon,
            ),
            SizedBox(
              height: 10,
            ),
            TypeTextField(
              labelText: "Phone Number",
              controller: controller.phoneCon,
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
              controller: controller.descriptionCon,
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
        );
      },
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.titleText,
        actions: [
          IconButton(
            onPressed: () {
              // itemFormCon.itemName.value = nameCon.text.trim();
              // itemFormCon.price.value = int.parse(priceCon.text.trim());
              // itemFormCon.mainCat.value = mainCat;
              // itemFormCon.subCat.value = subCat;
              // itemFormCon.address.value = addressCon.text.trim();
              // itemFormCon.phone.value = phoneCon.text.trim();
              // itemFormCon.description.value = descriptionCon.text.trim();
              widget.onConfirm!();
            },
            icon: Icon(
              Icons.check,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: widget.padding,
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
                        "(${itemFormCon.rawImages.length}/5)",
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
                    itemCount: (itemFormCon.rawImages.length == 5)
                        ? 5
                        : itemFormCon.rawImages.length + 1,
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
                child: buildTextInputForm(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
