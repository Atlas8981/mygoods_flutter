class Category {
  Category({
    required this.id,
    required this.mainCategory,
    required this.subCategory,
  });

  int id;
  String mainCategory;
  String subCategory;

  factory Category.fromMap(Map<String, dynamic> json) => Category(
    id: json["id"],
    mainCategory: json["mainCategory"],
    subCategory: json["subCategory"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "mainCategory": mainCategory,
    "subCategory": subCategory,
  };
}