import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:mygoods_flutter/models/token_response.dart';
import 'package:mygoods_flutter/utils/api_route.dart';

class AuthenticationService {
  Future<TokenResponse?> login(String email, String password) async {
    try {
      const url = "http://$domain:$port/api/login";
      final uri = Uri.parse(url);

      final response = await http.post(
        uri,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded',
        },
        body: {
          'username': "016409637",
          'password': "password",
        },
      );
      print("response.statusCode: ${response.statusCode}");
      if (response.statusCode == 200) {
        print("response.body" + response.body);
        final tokenResponse = tokenResponseFromMap(response.body);
        return tokenResponse;
      }
    } catch (e) {
      print(e);
      return null;
    }
    return null;
  }
}
