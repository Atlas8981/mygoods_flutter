
class MyImage {
  MyImage({
    required this.imageName,
    required this.imageUrl,
  });

  final String imageName;
  final String imageUrl;

  factory MyImage.fromJson(Map<String, dynamic> json) => MyImage(
    imageName: json["imageName"],
    imageUrl: json["imageURL"],
  );

  Map<String, dynamic> toJson() => {
    "imageName": imageName,
    "imageURL": imageUrl,
  };

  @override
  String toString() {
    return 'Image{imageName: $imageName, imageUrl: $imageUrl}';
  }
}