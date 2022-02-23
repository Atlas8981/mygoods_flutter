import 'dart:convert';

List<Image> getAllImageFromMap(String str) =>
    List<Image>.from(json.decode(str).map((x) => Image.fromMap(x)));

String getAllImageToMap(List<Image> data) =>
    json.encode(List<Image>.from(data.map((x) => x.toMap())));

class Image {
  Image({
    this.imageId,
    required this.imageUrl,
    required this.imageName,
  });

  int? imageId;
  String imageUrl;
  String imageName;

  factory Image.fromMap(Map<String, dynamic> json) => Image(
        imageId: json["imageId"],
        imageUrl: json["imageURL"],
        imageName: json["imageName"],
      );

  Map<String, dynamic> toMap() => {
        "imageId": imageId,
        "imageURL": imageUrl,
        "imageName": imageName,
      };

  factory Image.fromJson(Map<String, dynamic> json) => Image(
        imageName: json["imageName"],
        imageUrl: json["imageURL"],
      );

  Map<String, dynamic> toJson() => {
        "imageName": imageName,
        "imageURL": imageUrl,
      };
}
