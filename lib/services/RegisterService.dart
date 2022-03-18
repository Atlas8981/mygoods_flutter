import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:mygoods_flutter/models/user/userDto.dart';
import 'package:mygoods_flutter/utils/api_route.dart';

class RegisterService {
  Future<bool> register(UserDto userDto) async {
    try {
      const url = "http://$domain:$port/api/register";
      final uri = Uri.parse(url);

      final response = await http.post(
        uri,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: jsonEncode(userDto.toMap()),
      );
      print("response.statusCode: ${response.statusCode}");
      if (response.statusCode == 200) {
        return true;
      } else {
        print(response.body);
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
    return false;
  }

  Future<bool> verify(String username, String code) async {
    try {
      final url =
          "http://$domain:$port/api/verify?code=$code&username=$username";
      final uri = Uri.parse(url);

      final response = await http.post(
        uri,
      );
      print("response.statusCode: ${response.statusCode}");
      if (response.statusCode == 200) {
        if (response.body == "verify_fail") {
          return false;
        }
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
    return false;
  }
}
