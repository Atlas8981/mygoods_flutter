import 'package:get/get.dart';
import 'package:mygoods_flutter/services/remote_services.dart';

class ProductController extends GetxController {
  final productList = [].obs;

  @override
  void onInit() {
    fetchProducts();
    super.onInit();
  }

  void fetchProducts() async {
    var products = await RemoteServices.getProduct();
    if (products != null) {
      productList.value = products;
    }
  }
}
