import 'dart:io';

import 'package:get/get.dart';
import 'package:mygoods_flutter/controllers/AuthenticationController.dart';
import 'package:mygoods_flutter/models/image.dart';
import 'package:mygoods_flutter/utils/api_route.dart';
import 'package:http/http.dart' as http;

class ImageService {
  Future<List<Image>?> getImages() async {
    try {
      const url = "http://$domain:$port/api/v1/image";
      final uri = Uri.parse(url);

      final authCon = Get.find<AuthenticationController>();

      final response = await http.get(
        uri,
        headers: {
          HttpHeaders.authorizationHeader:
              "Bearer ${authCon.tokenRes!.value.accessToken}",
        },
      );

      print("response.statusCode: ${response.statusCode}");

      if (response.statusCode == 200) {
        final listOfImage = getAllImageFromMap(response.body);
        return listOfImage;
      }
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<String?> saveImage() async {
    try {
      const url = "http://$domain:$port/api/v1/image/save";
      final uri = Uri.parse(url);

      final authCon = Get.find<AuthenticationController>();

      final request = http.MultipartRequest("POST", uri);
      request.headers.addAll({
        'Authorization': 'Bearer ${authCon.tokenRes!.value.accessToken}',
      });
      request.files.add(await http.MultipartFile.fromPath("image", "filePath"));
      final response = await request.send();

      print("response.statusCode: ${response.statusCode}");

      if (response.statusCode == 200) {}
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
