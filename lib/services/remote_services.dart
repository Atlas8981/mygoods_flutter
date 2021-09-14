import 'package:http/http.dart' as http;
import 'package:mygoods_flutter/models/product.dart';

class RemoteServices {
  static var client = http.Client();

  static Future<List<Product>?> getProduct() async {
    var response = await client.get(Uri.parse("https://fakestoreapi.com/products"));

    if (response.statusCode == 200) {
      var jsonString = response.body;
      return productFromJson(jsonString);
    }else {
      return null;
    }
  }
}
