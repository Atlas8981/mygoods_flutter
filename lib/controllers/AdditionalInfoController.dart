import 'package:get/get.dart';
import 'package:mygoods_flutter/services/AdditionalDataService.dart';

class AdditionalInfoController extends GetxController {
  final AdditionalDataService additionalDataService = AdditionalDataService();

  final RxList carList = [].obs;
  final RxList phoneList = [].obs;

  @override
  void onInit() {
    super.onInit();
    getCarList();
  }

  void getCarList() {
    additionalDataService.getCarData().then((value) {
      if (value != null) {
        if (carList.isNotEmpty) {
          carList.clear();
        }
        carList.addAll(value);
      }
    });
  }
}
