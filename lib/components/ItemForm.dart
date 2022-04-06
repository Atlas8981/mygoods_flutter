import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mygoods_flutter/components/CategoryDropdownMenu.dart';
import 'package:mygoods_flutter/components/ClickableTextField.dart';
import 'package:mygoods_flutter/components/ListBottomSheet.dart';
import 'package:mygoods_flutter/components/TypeTextField.dart';
import 'package:mygoods_flutter/controllers/AdditionalInfoController.dart';
import 'package:mygoods_flutter/controllers/ItemFormController.dart';
import 'package:mygoods_flutter/models/DualImage.dart';
import 'package:mygoods_flutter/models/additionalInfo.dart';
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
  final formKey = GlobalKey<FormState>();
  final itemFormCon = Get.put(ItemFormController());
  final additionalInfoCon = Get.put(AdditionalInfoController());

  final conditions = ["New", "Used"];

  final ImagePicker _imagePicker = ImagePicker();

  bool showAdditionInfoForm(String subCat) {
    return hasAdditionalInfoList.contains(subCat);
  }

  void carProcedure() async {
    String selectBrand = "";
    String selectModel = "";
    String selectType = "";
    String selectYear = "";
    final List<Car> carList = additionalInfoCon.carList.cast();
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
      },
    );

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
          },
        );
      },
    );
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
          },
        );
      },
    );
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
          },
        );
      },
    );
  }

  void phoneProcedure() async {
    String selectBrand = "";
    String selectModel = "";
    final List<Phone> phoneList = additionalInfoCon.phoneList.cast<Phone>();
    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return CustomBottomSheetWithSearch(
          items: phoneList.map((e) => e.phoneBrand).toSet().toList(),
          onTapItem: (value) {
            selectBrand = value;
            Get.back();
          },
        );
      },
    );

    if (selectBrand.isEmpty) {
      return;
    }
    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return CustomBottomSheetWithSearch(
          items: phoneList.map((e) => e.phoneModel).toSet().toList(),
          onTapItem: (value) {
            selectModel = value;
            itemFormCon.additionalInfoCon.text = "$selectBrand, $selectModel";
            Get.back();
            setState(() {});
          },
        );
      },
    );
  }

  void processAdditionalInformation() {
    if (itemFormCon.subCat.value.capitalize == hasAdditionalInfoList[0]) {
      // phoneProcedure();
      showToast("Mok Dol Luv Hz");
    } else if (itemFormCon.subCat.value.capitalize ==
        hasAdditionalInfoList[1]) {
      // partAccessoriesComputerProcedure();
      showToast("Mok Dol Luv Hz");
    } else if (itemFormCon.subCat.value.capitalize ==
        hasAdditionalInfoList[2]) {
      carProcedure();
    } else if (itemFormCon.subCat.value.capitalize ==
        hasAdditionalInfoList[3]) {
      // motoProcedure();
      showToast("Mok Dol Luv Hz");
    } else if (itemFormCon.subCat.value.capitalize ==
        hasAdditionalInfoList[4]) {
      // bikeProcedure();
      showToast("Mok Dol Luv Hz");
    }
  }

  void _imageFromGallery(index) async {
    final List<XFile>? rawXfile = await _imagePicker.pickMultiImage();
    if (rawXfile == null) {
      showToast("Image not picked");
    }
    if (rawXfile!.length > 5) {
      showToast("Select Less than 5 Images");
    }
    final totalImage = (itemFormCon.tempImages.length + rawXfile.length);
    if (totalImage <= 5) {
      setState(() {
        for (var picture in rawXfile) {
          itemFormCon.addImage(DualImage(false, imagePath: picture.path));
        }
      });
    } else {
      showToast("Total images exceed 5");
    }
  }

  buildAddImageRow(context, index) {
    final List<DualImage> tempImages = itemFormCon.tempImages.cast();
    if (index < tempImages.length) {
      return Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              padding: const EdgeInsets.all(5),
              child: Card(
                margin: const EdgeInsets.all(0),
                elevation: 5,
                child: InkWell(
                  onTap: () {},
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image(
                      image: checkImageProvider(tempImages[index]),
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
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
                FocusScope.of(context).requestFocus(FocusNode());
                setState(() {
                  tempImages.removeAt(index);
                });
              },
              child: const Icon(
                Icons.indeterminate_check_box_outlined,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ],
      );
    } else {
      return Card(
        elevation: 5,
        child: Container(
          width: 120,
          height: 120,
          padding: const EdgeInsets.all(5),
          child: IconButton(
            onPressed: () {
              FocusScope.of(context).requestFocus(FocusNode());
              _imageFromGallery(index);
            },
            icon: const Icon(
              Icons.add,
              size: 48,
            ),
          ),
        ),
      );
    }
  }

  buildTextInputForm() {
    return GetBuilder<ItemFormController>(
      builder: (controller) {
        return Form(
          key: controller.formKey,
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: TypeTextField(
                      labelText: "Item Name",
                      controller: controller.nameCon,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: TypeTextField(
                      labelText: "Price",
                      controller: controller.priceCon,
                      inputType: const TextInputType.numberWithOptions(
                        decimal: true,
                        signed: false,
                      ),
                      suffixIcon: Icon(
                        Icons.attach_money,
                        color: context.iconColor,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Empty Field";
                        }
                        if (!GetUtils.isNum(value)) {
                          return "Not a Number";
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
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
                        titlePadding: const EdgeInsets.all(10),
                        contentPadding: const EdgeInsets.all(10),
                        actionsPadding: const EdgeInsets.all(10),
                        title: const Text("Select Category"),
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
              const SizedBox(
                height: 10,
              ),
              Visibility(
                visible: showAdditionInfoForm(controller.subCat.value),
                maintainSize: false,
                child: Column(
                  children: [
                    ClickableTextField(
                      labelText:
                          "Enter ${itemFormCon.subCat.value.capitalize} Information",
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
                    const SizedBox(
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
                    ListButtonSheet(
                      items: conditions,
                      onItemClick: (index) {
                        setState(() {
                          controller.conditionCon.text = conditions[index];
                        });
                      },
                    ),
                    backgroundColor: Colors.white,
                  );
                },
              ),
              const SizedBox(height: 10),
              TypeTextField(
                labelText: "Address",
                controller: controller.addressCon,
              ),
              const SizedBox(height: 10),
              TypeTextField(
                labelText: "Phone Number",
                controller: controller.phoneCon,
                inputType: TextInputType.phone,
                prefix: "0",
                maxLength: 9,
                buildCounter: (context,
                    {required currentLength, required isFocused, maxLength}) {
                  return Text(
                    '${currentLength + 1}/${maxLength! + 1}',
                    semanticsLabel: 'character count',
                    style: const TextStyle(fontSize: 12, height: 1),
                  );
                },
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
              const SizedBox(height: 10),
              TextField(
                controller: controller.descriptionCon,
                maxLength: 200,
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontSize: 16,
                ),
                keyboardType: TextInputType.multiline,
                maxLines: 5,
                decoration: const InputDecoration(
                  alignLabelWithHint: true,
                  contentPadding: EdgeInsets.all(10),
                  labelStyle: TextStyle(
                    fontSize: 16,
                  ),
                  labelText: "Description",
                  border: OutlineInputBorder(),
                  counterStyle: TextStyle(
                    fontSize: 12,
                    height: 1,
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    itemFormCon.formKey = formKey;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.titleText,
        actions: [
          GestureDetector(
            onLongPress: () {
              itemFormCon.clearData();
            },
            child: IconButton(
              onPressed: () {
                showToast("Long Press to Clear Data");
              },
              icon: const Icon(
                Icons.refresh,
                color: Colors.white,
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              widget.onConfirm!();
            },
            icon: const Icon(
              Icons.check,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
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
                      const Text(
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
                            "(${itemFormCon.tempImages.length}/5)",
                            style: const TextStyle(fontSize: 16),
                          );
                        }),
                      ),
                    ],
                  ),

                  //Horizontal Image View
                  SizedBox(
                    height: 120,
                    child: Obx(() {
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: (itemFormCon.tempImages.length == 5)
                            ? 5
                            : itemFormCon.tempImages.length + 1,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return buildAddImageRow(context, index);
                        },
                      );
                    }),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  //Forms
                  buildTextInputForm(),
                ],
              ),
            ),
          ),
          Obx(
            () => Visibility(
              visible: itemFormCon.isVisible.value,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
