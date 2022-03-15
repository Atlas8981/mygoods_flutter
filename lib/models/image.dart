class Image {
  Image({
    required this.imageId,
    required this.imageUrl,
    required this.imageName,
    required this.item,
    required this.user,
  });

  int imageId;
  String imageUrl;
  String imageName;
  dynamic item;
  dynamic user;

  factory Image.fromMap(Map<String, dynamic> json) => Image(
    imageId: json["imageId"],
    imageUrl: json["imageURL"],
    imageName: json["imageName"],
    item: json["item"],
    user: json["user"],
  );

  Map<String, dynamic> toMap() => {
    "imageId": imageId,
    "imageURL": imageUrl,
    "imageName": imageName,
    "item": item,
    "user": user,
  };
}
