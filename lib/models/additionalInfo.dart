import 'dart:convert';

AdditionalInfo additionalInfoFromJson(String str) =>
    AdditionalInfo.fromJson(json.decode(str));

String additionalInfoToJson(AdditionalInfo data) => json.encode(data.toJson());

AdditionalInfo additionalInfoFromFirestore(Map<String, dynamic> json) =>
    AdditionalInfo.fromJson(json);

class AdditionalInfo {
  AdditionalInfo(
      {this.car,
      this.phone,
      this.motoType,
      this.computerParts,
      this.condition,
      this.bikeType});

  Car? car;
  Phone? phone;
  String? motoType;
  String? computerParts;
  String? condition;
  String? bikeType;

  @override
  String toString() {
    return 'AdditionalInfo{car: $car, phone: $phone, motoType: $motoType, computerParts: $computerParts, condition: $condition, bikeType: $bikeType}';
  }

  factory AdditionalInfo.fromJson(Map<String, dynamic> json) {
    AdditionalInfo tempAdditionalInfo = AdditionalInfo();
    if (json["car"] != null) {
      tempAdditionalInfo.car = Car.fromJson(json["car"]);
    }
    if (json["phone"] != null) {
      tempAdditionalInfo.phone = Phone.fromJson(json["phone"]);
    }
    if (json["motoType"] != null) {
      tempAdditionalInfo.motoType = json["motoType"];
    }
    if (json["computerParts"] != null) {
      tempAdditionalInfo.computerParts = json["computerParts"];
    }
    if (json["condition"] != null) {
      tempAdditionalInfo.condition = json["condition"];
    }
    if (json["bikeType"] != null) {
      tempAdditionalInfo.bikeType = json["bikeType"];
    }
    return tempAdditionalInfo;
    // return AdditionalInfo(
    //     car: Car.fromJson(json["car"]),
    //     phone: Phone.fromJson(json["phone"]),
    //     motoType: json["motoType"],
    //     computerParts: json["computerParts"],
    //     condition: json["condition"],
    //     bikeType: json["bikeType"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "car": car!.toJson(),
      "phone": phone!.toJson(),
      "motoType": motoType,
      "computerParts": computerParts,
      "condition": condition,
      "bikeType": bikeType,
    };
  }
}

class Car {
  Car(
      {required this.brand,
      required this.model,
      required this.category,
      required this.year});

  final String brand;
  final String model;
  final String category;
  final String year;

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
        brand: json["brand"],
        model: json["model"],
        category: json["category"],
        year: json["year"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "brand": brand,
      "model": model,
      "category": category,
      "year": year,
    };
  }

  @override
  String toString() {
    return 'Car{brand: $brand, model: $model, category: $category, year: $year}';
  }
}

class Phone {
  final String phoneBrand;
  final String phoneModel;

  Phone({required this.phoneBrand, required this.phoneModel});

  @override
  String toString() {
    return 'Phone{phoneBrand: $phoneBrand, phoneModel: $phoneModel}';
  }

  factory Phone.fromJson(Map<String, dynamic> json) {
    return Phone(
        phoneBrand: json["phoneBrand"], phoneModel: json["phoneModel"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "phoneBrand": phoneBrand,
      "phoneModel": phoneModel,
    };
  }
}
