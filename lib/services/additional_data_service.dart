import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mygoods_flutter/models/additionalInfo.dart';

class AdditionalDataService {
  Future<List<Car>?> getCarData() async {
    final headers = {
      'X-Parse-Application-Id': 'hlhoNKjOvEhqzcVAJ1lxjicJLZNVv36GdbboZj3Z',
      'X-Parse-Master-Key': 'SNMJJF0CZZhTPhLDIqGhTlUNV9r60M2Z5spyWfXW',
    };
    final int limit = 9581;
    final String order = "Make";
    final String url =
        "https://parseapi.back4app.com/classes/Car_Model_List?limit=$limit&order=$order";
    var uri = Uri.parse(url);
    var response = await http.get(uri, headers: headers);
    final responseBody = response.body;
    final getCarData = jsonDecode(responseBody);
    if (response.statusCode == 200) {
      List<Car> cars = List<Car>.from(
          getCarData['results'].map((x) => Car.fromBack4AppJson(x)));
      return cars;
    } else {
      return null;
    }
    // return response;
  }
// Future<http.Response> login(String email, String password) async {
//   const String grantType = "password";
//   var headers = {
//     'Authorization': 'Basic bW9iaWxlLWFnZW50LWFwcDpQQHNzdzByZA==',
//     'Content-Type': 'application/x-www-form-urlencoded'
//   };
//
//   final String url = "http://$domain:$port/oauth/token";
//
//   var uri = Uri.parse(url);
//   var response = await http.post(
//     uri,
//     body: {
//       'grant_type': '$grantType',
//       'username': '$email',
//       "password": "$password",
//     },
//     headers: headers,
//   );
//
//   return response;
//
// }
}
