class ItemDto {
  ItemDto({
    required this.date,
    required this.subCategory,
    required this.amount,
    required this.address,
    required this.description,
    required this.userid,
    required this.viewers,
    required this.phone,
    required this.price,
    required this.name,
    required this.mainCategory,
  });

  DateTime date;
  String subCategory;
  int amount;
  String address;
  String description;
  String userid;
  List<String> viewers;
  String phone;
  double price;
  String name;
  String mainCategory;

  Map<String, dynamic> toJson() => {
    "date": date.toString(),
    "subCategory": subCategory,
    "amount": amount.toString(),
    "address": address,
    "description": description,
    "userid": userid,
    "viewers": List<dynamic>.from(viewers.map((x) => x)).toString(),
    "phone": phone,
    "price": price.toString(),
    "name": name,
    "mainCategory": mainCategory,
  };

  @override
  String toString() {
    return 'Item{date: $date, '
        'subCategory: $subCategory, '
        'amount: $amount, '
        'address: $address, '
        'description: $description, '
        'userid: $userid, '
        'viewers: $viewers, '
        'phone: $phone, '
        'price: $price, '
        'name: $name, '
        'mainCategory: $mainCategory, '
        '}';
  }
}
